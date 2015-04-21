# Project Template for Library Plugins (Lua)


## Overview

This is a template/stationary for those interested in packaging Lua code into a reusable [library plugin](http://docs.coronalabs.com/native/plugin/index.html#types-of-plugins). You can use these plugins in your own [Corona](https://coronalabs.com/products/corona-sdk/) projects or distribute them in the [Corona Store](https://store.coronalabs.com/plugins)


## New projects

### Creating your project

To create a new project, we have provided helper scripts that can do the necessary file renaming and string replacements for both Mac OS X and Windows.

#### Mac

Run the script [create_project.sh](create_project.sh) in Terminal:

```
cd /path/to/this/repo/
./create_project.sh /path/to/new/project/folder PLUGIN_NAME
```

#### Windows

Run the script [create_project.bat](create_project.bat) in the command prompt:

```
cd \path\to\this\repo\
create_project.bat \path\to\new\project\folder PLUGIN_NAME
```

### Project Files

Your new project should contain the following files and folders:

* [bin/](bin/): Core binaries required to compile plugins into bytecode.
+ [build.bat](build.bat): Compiles and packages the plugin for distribution using Windows.
+ [build.sh](build.sh): Compiles and packages the plugin for distribution using a Mac.
* [metadata.json](metadata.json): Contains publisher information, including contact and website data.
* [plugins/VERSION/lua/](plugins/2015.2511/lua/)
	+ The files here are included for users using the Simulator version VERSION or higher.
	+ As an example, plugins/2015.2511/lua/ requires a minimum SDK version 2015.2511 to be included.


## Library Plugin Development

### Workflow

__NOTE:__ _You should use dailybuild 2015.2610 or higher when developing your plugins. If you are using a previous version, you will have to "flatten" the plugin file ( `plugin/PLUGIN_NAME.lua` => `plugin_PLUGIN_NAME.lua`) in order to load it in the Corona Simulator. You can still target versions earlier than 2015.2610; this is purely a convenience feature for plugin developers starting in 2015.2610._

For rapid testing and development, it is suggested that you build your library locally and test your code as part of a normal project before moving it into a plugin library.

If you want to test it in the plugin environment, you can quickly copy and edit your plugin in the plugin download directory:

* Mac: `~/Library/Application Support/Corona/Simulator/Plugins/`
* Windows: `%APPDATA%\Roaming\Corona Labs\Corona Simulator\Plugins`

### Library Plugin File

The stub library plugin is something you should modify for your own purposes. The functionality implemented in the stub is explained in the [Doc Template for Library Docs](https://github.com/coronalabs/plugins-template-library-docs)

### Device Testing

Device testing is critical for several reasons:

* If your plugin uses shaders, there are subtle differences in the flavor of GLSL that runs on desktop vs mobile.
* Even though your code compiles on a desktop (Mac/Win), you should make sure it also compiles and runs on the device.


## Corona Store Submission

### Preparing for Submission

If you'd like to submit a plugin, there are a few more steps you need to take:

1. Update [metadata.json](metadata.json). 
	* This contains several strings in ALL CAPS that should be replaced with information specific to your plugin. 
	* While the helper script has already done a replacement of `PLUGIN_NAME` for you, there are still several strings that need to be updated.
	* Please see the section `Replacing strings in ALL CAPS` in the [Plugin Submission Guidelines](http://docs.coronalabs.com/daily/native/plugin/submission.html) for a complete list.
2. Device Testing
	* See [Device Testing](#device-testing) above.
	* You should make sure your code executes on iOS and Android devices. 
	* Verify that your code compiles on device
	* Understand potential performance issues on lower-end devices.
3. Documentation
	* Fork or clone [Doc Template for Library Docs](https://github.com/coronalabs/plugins-template-library-docs)
	* Follow the [Instructions](https://github.com/coronalabs/plugins-template-library-docs/blob/master/Instructions.markdown)
4. Sample Code
	* Post sample code online, e.g. github.

### Packaging Your Plugin

The packaging of your submission should follow a specific structure.

There is a convenience script that takes care of creating this structure (`build.sh` or `build.bat`). You must provide it with the daily build number corresponding to the minimum supported version of Corona (e.g. the first version of Corona you'd like the plugin to work with).

#### Example

For example, let's pretend we are submitting this repo's project. We'd like it to start working with daily build 2015.2560, so we would do the following:

* Rename `plugins/2015.2511` to `plugins/2015.2560`.

Next, we build our plugin. This converts your code into bytecode and prepares it for submission to the Corona Plugin Store. When this is complete, you will have a `plugin-<PLUGIN_NAME>.zip` file in your project directory, fit for uploading.

##### Mac

```
cd /path/to/this/repo/
./build.sh
```

##### Windows

```
cd /path/to/this/repo/
build.bat
```
