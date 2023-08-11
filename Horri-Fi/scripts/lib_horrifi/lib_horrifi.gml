/// @ignore
function __horriFi() 
{
	static enabled = true;
	static time    = 0;
	
	// Vignette settings
	static vignette =
	{
		enabled  : false,
		strength : 0, //.25,
		intensity: 0, //.5
	};
	
	// Noise settings
	static noise =
	{
		enabled : false,
		strength: 0, // 0.1
	};
	
	// Chromatic abberation settings
	static chromatic_abberation =
	{
		enabled : false,
		strength: 0 // .3
	};
	
	// Bloom
	static bloom =
	{
		enabled   : false,
		radius    : 0, // 8
		intensity : 0, // 1
		threshold : 0  // 0.8
	};
	
	// VHS Distortion
	static vhs =
	{
		enabled  : false,
		strength : 0 // .5
	};
	
	// Scanlines
	static scanlines =
	{
		enabled : false,
		strength: 0 //.25
	};
		
	// CRT Curve
	static crt =
	{
		enabled : false,
		curve : 0 // 2
	};
	
	static uniEnable  = shader_get_uniform(shd_horrifi, "enable");
	static uniTime    = shader_get_uniform(shd_horrifi, "time");
	static uniSeed    = shader_get_uniform(shd_horrifi, "seed");
	static uniTexel   = shader_get_uniform(shd_horrifi, "texel");
	static uniVig     = shader_get_uniform(shd_horrifi, "vignette");
	static uniNstr    = shader_get_uniform(shd_horrifi, "noise_strength");
	static uniChab    = shader_get_uniform(shd_horrifi, "chab_intensity");
	static uniBloom   = shader_get_uniform(shd_horrifi, "bloom");
	static uniScanStr = shader_get_uniform(shd_horrifi, "scan_strength");
	static uniVhs     = shader_get_uniform(shd_horrifi, "vhs_strength");
	static uniCurve   = shader_get_uniform(shd_horrifi, "curve");
	
	/// @desc Render horriFi
	static render = function()
	{
		if ( !enabled ) exit;
			
		var _w, _h, _s;
		_s = surface_get_texture(application_surface);
		_w = texture_get_texel_width(_s);
		_h = texture_get_texel_height(_s);
		
		// Set shader
		shader_set(shd_horrifi);
		
		// Enable effects
		shader_set_uniform_f_array( uniEnable, 
			[ 
				bloom.enabled, 
				chromatic_abberation.enabled, 
				noise.enabled, 
				vignette.enabled,
				scanlines.enabled,
				vhs.enabled,
				crt.enabled
			]
		);
		
		// Set effects parameters
		shader_set_uniform_f(uniTexel, _w, _h);
		shader_set_uniform_f(uniTime, time++);
		shader_set_uniform_f(uniSeed, 1+random(100));
		shader_set_uniform_f(uniVig, vignette.intensity, vignette.strength);
		shader_set_uniform_f(uniNstr, noise.strength);
		shader_set_uniform_f(uniChab, chromatic_abberation.strength);
		shader_set_uniform_f(uniBloom, bloom.radius, bloom.intensity, bloom.threshold);
		shader_set_uniform_f(uniScanStr, scanlines.strength);
		shader_set_uniform_f(uniVhs, vhs.strength);
		shader_set_uniform_f(uniCurve, crt.curve, crt.curve);
	}
	
	/// @desc Resetting
	static reset = function()
	{
		if ( enabled ) shader_reset();
	}
		
	/// @desc Export current configuration to a json string
	static export = function()
	{
		static this = static_get(__horriFi);
		// Feather ignore GM1041
		var _this = this;
		var _keys = variable_struct_get_names(_this);
		// Convert to JSON
		var _export = {
			__horrifi: true, 
			enabled: _this.enabled, 
			time:    _this.time,
			
			vignette:  _this.vignette,
			noise:     _this.noise,
			bloom:     _this.bloom,
			vhs:       _this.vhs,
			scanlines: _this.scanlines,
			crt:       _this.crt,
			
			chromatic_abberation: _this.chromatic_abberation,
		};
		
		return (json_stringify(_export) );
	}
		
	/// @desc Import the values of a json string
	static import = function(_horrifiJSON)
	{
		static this = static_get(__horriFi);
		var _import = (!is_struct(_horrifiJSON) ) ? json_parse(_horrifiJSON) : _horrifiJSON;
		if ( !variable_struct_exists(_import, "__horrifi") ) exit;
		with (this) {
			enabled = _import.enabled;
			time    = _import.time;
			
			var _keys = variable_struct_get_names(_import);
			var i=0; repeat( array_length( _keys ) ) {
				var _key   = _keys[i];
				var _param = _import[$ _key];
				
				self[$ _key] = _param;

				i++;
			}
		}
	}
	
}

// start statics
__horriFi();

// Main functions
function horrifi_enable(onoff)
{
	///@func horrifi_enable(enable)
	__horriFi.enabled = onoff;
}
function horrifi_is_enabled()
{
	return __horriFi.enabled;
}	
function horrifi_set()
{
	__horriFi.render();
}
function horrifi_reset()
{	
	__horriFi.reset();
}

/// @desc Export current configuration to a json string
function horrifi_export() 
{
	return ( __horriFi.export() );
}

/// @desc Import the values of a json string
/// @param {string} horrifiJSON 
function horrifi_import(_json)
{
	return ( __horriFi.import(_json) );
}


// Bloom functions
function horrifi_bloom_enable(onoff)
{
	///@func horrifi_bloom_enable(enable)
	__horriFi.bloom.enabled = onoff;
}
function horrifi_bloom_radius(rad)
{
	///@func horrifi_bloom_radius(radius)
	__horriFi.bloom.radius = rad;
}
function horrifi_bloom_intensity(int)
{
	///@func horrifi_bloom_intensity(intensity)
	__horriFi.bloom.intensity = int;
}	
function horrifi_bloom_threshold(thresh)
{
	///@func horrifi_bloom_threshold(threshold)
	__horriFi.bloom.threshold = thresh;
}
function horrifi_bloom_is_enabled()
{
	return __horriFi.bloom.enabled;	
}
function horrifi_bloom_get_radius()
{
	return __horriFi.bloom.radius;	
}
function horrifi_bloom_get_intensity()
{
	return __horriFi.bloom.intensity;	
}
function horrifi_bloom_get_threshold()
{
	return __horriFi.bloom.threshold;	
}
function horrifi_bloom_set(e,r,i,t)
{
	///@func horrifi_bloom_set(enabled, radius, intensity, threshold)
	horrifi_bloom_enable(e);
	horrifi_bloom_radius(r);
	horrifi_bloom_intensity(i);
	horrifi_bloom_threshold(t);
}
	
// Chromatic Abberation functions
function horrifi_chromaticab_enable(onoff)
{
	///@func horrifi_chromaticab_enable(enable)
	__horriFi.chromatic_abberation.enabled = onoff;
}	
function horrifi_chromaticab_strength(str)
{
	///@func horrifi_chromaticab_strength(strength)
	__horriFi.chromatic_abberation.strength = str;
}
function horrifi_chromaticab_is_enabled()
{
	return __horriFi.chromatic_abberation.enabled;
}
function horrifi_chromaticab_get_strength()
{
	return __horriFi.chromatic_abberation.strength;	
}
function horrifi_chromaticab_set(e,s)
{
	///@func horrifi_chromaticab_set(enable, strength)
	horrifi_chromaticab_enable(e);
	horrifi_chromaticab_strength(s);
}

// Noise functions
function horrifi_noise_enable(onoff)
{
	///@func horrifi_noise_enable(enable)
	__horriFi.noise.enabled = onoff;
}	
function horrifi_noise_strength(str)
{
	///@func horrifi_noise_strength(strength)
	__horriFi.noise.strength = str;
}
function horrifi_noise_is_enabled()
{
	return __horriFi.noise.enabled;
}
function horrifi_noise_get_strength()
{	
	return __horriFi.noise.strength;
}
function horrifi_noise_set(e, s)
{
	///@func horrifi_noise_set(enable, strength)
	horrifi_noise_enable(e);
	horrifi_noise_strength(s);
}

// Vignette functions
function horrifi_vignette_enable(onoff)		
{
	///@func horrifi_vignette_enable(enable)	
	__horriFi.vignette.enabled=onoff
}
function horrifi_vignette_strength(str)		
{
	///@func horrifi_vignette_strength(strength)	
	__horriFi.vignette.strength = str;
}
function horrifi_vignette_intensity(int)	
{
	///@func horrifi_vignette_intensity(intensity)
	__horriFi.vignette.intensity = int;
}
function horrifi_vignette_is_enabled()		
{
	return __horriFi.vignette.enabled;
}
function horrifi_vignette_get_strength()	
{
	return __horriFi.vignette.strength;
}
function horrifi_vignette_get_intensity()	
{
	return __horriFi.vignette.intensity;
}
function horrifi_vignette_set(e,s,i)
{
	///@func horrifi_vignette_set(enable, strength, intensity)
	horrifi_vignette_enable(e);
	horrifi_vignette_strength(s);
	horrifi_vignette_intensity(i);
}

// VHS functions
function horrifi_vhs_enable(onoff)
{
	///@func horrifi_vhs_enable(enable)
	__horriFi.vhs.enabled = onoff;
}	
function horrifi_vhs_strength(str)
{
	///@func horrifi_vhs_strength(strength)
	__horriFi.vhs.strength = str;
}
function horrifi_vhs_is_enabled()
{
	return __horriFi.vhs.enabled;	
}
function horrifi_vhs_get_strength()
{
	return __horriFi.vhs.strength;	
}
function horrifi_vhs_set(e,s)
{
	///@func horrifi_vhs_set(enable, strength)
	horrifi_vhs_enable(e);
	horrifi_vhs_strength(s);
}

// Scanlines functions
function horrifi_scanlines_enable(onoff)
{
	///@func horrifi_scanlines_enable(enable)
	__horriFi.scanlines.enabled = onoff;
}	
function horrifi_scanlines_strength(str)
{
	///@func horrifi_scanlines_strength(strength)
	__horriFi.scanlines.strength = str;
}
function horrifi_scanlines_is_enabled()
{
	return __horriFi.scanlines.enabled;	
}
function horrifi_scanlines_get_strength()
{
	return __horriFi.scanlines.strength;	
}
function horrifi_scanlines_set(e,s)
{
	///@func horrifi_scanlines_set(enable, strength)
	horrifi_scanlines_enable(e);
	horrifi_scanlines_strength(s);
}

// CRT functions
function horrifi_crt_enable(onoff)
{
	///@func horrifi_crt_enable(enable)
	__horriFi.crt.enabled = onoff;
}	
function horrifi_crt_curve(str1)
{
	///@func horrifi_crt_curve(strength)
	__horriFi.crt.curve = str1;
}
function horrifi_crt_is_enabled()
{
	return __horriFi.crt.enabled;	
}
function horrifi_crt_get_curve()
{
	return __horriFi.crt.curve;	
}
function horrifi_crt_set(e,s1)
{
	///@func horrifi_crt_set(enable, curve)
	horrifi_crt_enable(e);
	horrifi_crt_curve(s1);
}