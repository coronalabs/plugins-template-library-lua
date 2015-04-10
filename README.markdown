# Project Template for Library Plugins (Lua)

## Overview

This is a template/stationary for those interested in packaging Lua code into a reusable [library plugin](http://docs.coronalabs.com/native/plugin/index.html#types-of-plugins).

You can use these plugins in your own [Corona](https://coronalabs.com/products/corona-sdk/) projects or distribute them in the [Corona Store](https://store.coronalabs.com)


## New projects

### Creating your project

To create a new project, the simplest process is to run [create_project.sh](create_project.sh) which requires a BASH shell:

```
cd /path/to/this/repo/
./create_project.sh /path/to/new/project/folder PLUGIN_NAME
```

If you do not have access to BASH, see [Manual Project Creation](#manual-project-creation) below.

(TODO: Create a .bat script for Windows users.)


### Project Files

Your new project should contain the following files and folders:

* [build.sh](build.sh)
* [lua/](lua/)
	+ __Test Harness:__
		+ [build.settings](lua/build.settings)
		+ [config.lua](lua/config.lua)
		+ [main.lua](lua/main.lua)
	+ __Plugin:__
		+ [plugin/PLUGIN_NAME.lua](lua/plugin/PLUGIN_NAME.lua)
			- This is a stub/sample library implementation that implements saving a table to a file and loading it back via JSON.
* [metadata.json](metadata.json)
* [README.markdown](README.markdown)


## Library Plugin Development

### Workflow

__NOTE:__ _You should use dailybuild 2015.2610 or higher. If you are using a previous version, you will have to "flatten" the plugin file ( `plugin/PLUGIN_NAME.lua` => `plugin_PLUGIN_NAME.lua`) in order to load it in the Corona Simulator._

For workflow convenience, the test harness and library plugin code are integrated to simplify shader effect development:

* The test harness is in the [lua/](lua/) folder, including the [lua/main.lua](lua/main.lua) file.
* The library plugin is in the subfolder of the test harness: [lua/plugin/PLUGIN_NAME.lua](lua/plugin/PLUGIN_NAME.lua).

That way, you can open the test harness in the Corona Simulator, modify your shader effects, and preview those changes immediately.

You can also open the test harness in [CoronaViewer](https://github.com/coronalabs/CoronaViewer) to preview those changes immediately on a device.


### Library Plugin File

The stub/sample library plugin is something you should modify for your own purposes.


### Device Testing

Device testing is very critical for several reasons:

* There are subtle differences in the flavor of GLSL that runs on desktop vs mobile. Even though your shader code compiles on a desktop (Mac/Win), you should make sure it also compiles on the device.
* Mobile GPU's also have key performance differences that will not be apparent when running in the Corona Simulator. You should verify that the performance of your shader effect is acceptable on a wide range of devices. In general, you will want to run it on the oldest device you plan to support.

[CoronaViewer](https://github.com/coronalabs/CoronaViewer) is a convenient way to develop your shader on a device, offering a similar workflow to the Corona Simulator.


## Corona Store Submission

### Preparing for Submission

If you'd like to submit a plugin, there are a few more steps you need to take:

1. Update [metadata.json](metadata.json). 
	* This contains several strings in ALL CAPS that should be replaced with information specific to your plugin. 
	* While the helper script has already done a replacement of `PLUGIN_NAME` for you, there are still several strings that need to be updated.
	* Please see the section `Replacing strings in ALL CAPS` in the [Plugin Submission Guidelines](http://docs.coronalabs.com/daily/native/plugin/submission.html) for a complete list.
2. Device Testing
	* See [Device Testing](#device-testing) above.
	* You should make sure your shader executes on iOS and Android devices. 
	* Verify that your shader code compiles on device
	* Understand potential performance issues on lower-end devices.
	* NOTE: Windows Phone 8 only supports precompiled shaders, so custom shader effects are not supported by those devices.
3. Documentation
	* Fork or clone [Doc Template for Library Docs](https://github.com/coronalabs/plugins-template-library-docs)
	* Follow the [Instructions](https://github.com/coronalabs/plugins-template-library-docs/blob/master/Instructions.markdown)
4. Sample Code
	* Post sample code online, e.g. github.

### Packaging Your Plugin

* There is a convenience script that takes care of packaging your plugin for submission to the Corona Store.
* To run the script, open a Terminal to your project's root folder. There should be a script called `build.sh` that you can run:

```
./build.sh
```

This will create several files:

* a `build/` folder
* a `build-{PLUGIN_NAME}.zip` that contains all the files in `build/`. This is the file you should submit.


## Appendix

### Namespace Details

The template project in this repo is designed to namespace your custom shader effects.

The string token `PLUGIN_NAME` is used in the names of files/folders and in the contents of files. The [create_project.sh](create_project.sh) replaces occurrences of `PLUGIN_NAME` appropriately.

### Manual Project Creation

As explained in 'Namespace Details', the [create_project.sh](create_project.sh) does bulk string replacement for you. 

You can manually replace all occurrences of `PLUGIN_NAME` yourself. Be sure to do this inside the contents of files __and__ in the names of files/folders themselves.

