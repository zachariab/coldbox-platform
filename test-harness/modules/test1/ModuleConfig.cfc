﻿<cfcomponent output="false" hint="My App Configuration">
<cfscript>
/**
Module Directives as public properties
this.title 				= "Title of the module";
this.author 			= "Author of the module";
this.webURL 			= "Web URL for docs purposes";
this.description 		= "Module description";
this.version 			= "Module Version"

Optional Properties
this.viewParentLookup   = (true) [boolean] (Optional) // If true, checks for views in the parent first, then it the module.If false, then modules first, then parent.
this.layoutParentLookup = (true) [boolean] (Optional) // If true, checks for layouts in the parent first, then it the module.If false, then modules first, then parent.
this.entryPoint  		= "" (Optional) // If set, this is the default event (ex:forgebox:manager.index) or default route (/forgebox) the framework
									       will use to create an entry link to the module. Similar to a default event.

structures to create for configuration
- parentSettings : struct (will append and override parent)
- settings : struct
- datasources : struct (will append and override parent)
- interceptorSettings : struct of the following keys ATM
	- customInterceptionPoints : string list of custom interception points
- interceptors : array
- layoutSettings : struct (will allow to define a defaultLayout for the module)
- routes : array Allowed keys are same as the addRoute() method of the SES interceptor.
- modelMappings : structure of model mappings. Allowed keys are the alias and path, same as normal model mappings.

Available objects in variable scope
- controller
- appMapping (application mapping)
- moduleMapping (include,cf path)
- modulePath (absolute path)
- log (A pre-configured logBox logger object for this object)

Required Methods
- configure() : The method ColdBox calls to configure the module.

Optional Methods
- onLoad() 		: If found, it is fired once the module is fully loaded
- onUnload() 	: If found, it is fired once the module is unloaded

*/

	// Module Properties
	this.title 				= "My Test Module";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.coldbox.org";
	this.description 		= "A funky test module";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	this.entryPoint			= "test1";

	function configure(){

		// parent settings
		parentSettings = {
			woot = "Module set it!"
		};

		// module settings - stored in modules.name.settings
		settings = {
			display = "core"
		};

		// datasources
		datasources = {
			mysite   = {name="mySite", dbType="mysql", username="root", password="root"}
		};

		// SES Routes
		routes = [
			{ pattern="/", handler="test",action="index" },
			{ pattern="/:handler/:action?" }
		];

		// Interceptor Config
		interceptorSettings = {
			customInterceptionPoints = "onPio"
		};
		// All declared interceptor
		interceptors = [
			{class="#moduleMapping#.interceptors.Simple"}
		];

		// i18n
		i18n = {
			defaultLocale = "es_SV",
			resourceBundles = {
				"module@test1" = "#moduleMapping#/includes/module"
			}
		};

	}

	function onLoad(){
		controller.getLogBox().getLogger(this).info("onLoad called on module: #getMetadata(this).name#");
	}

	function onUnload(){
		controller.getLogBox().getLogger(this).info("onUnload called on module: #getMetadata(this).name#");
	}

	// This object can also act as an interceptor
	function preProcess(event,interceptData){
		controller.getLogBox().getLogger(this).info("I can now listen on preprocess from the Test1 Module");
	}

	/**
	* @interceptionPoint
	*/
	function onPio(event, interceptData){
		controller.getLogBox().getLogger(this).info("I can now listen onPio");
	}

</cfscript>
</cfcomponent>