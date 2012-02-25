/**
 * inspired by http://play.blog2t.net/finding-the-missing-child/ 
 */
package  
{  
	import avmplus.getQualifiedClassName;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	
	
	/**
	 * Recursively searches a container for nested children that match the specified class- and/or instance name.
	 * The class name can be '&#42;', the direct classname, or the full qualified classname in the format 'package.subpackage::classname'.
	 * @param className Either '&#42;', the simple, or the qualified class name to search for.
	 * @param instanceName The name of the searched instance
	 */
	public function findChild(container:DisplayObjectContainer, className:String, instanceName:String = null):Array
	{  
		var i:int = container.numChildren;  
		var result:Array = [];
		while (i--)  
		{  
			var classNameMatch:Boolean = false;
			var instanceNameMatch:Boolean = false;
			var child:DisplayObject = container.getChildAt(i);  
			
			if (className == '*') {
				classNameMatch = true;
			}
			else {
				var childClass:String = getQualifiedClassName(child);
				if (className.indexOf('::') == -1) {
					childClass = childClass.split('::')[1];
				} 
				classNameMatch = childClass == className;
			}
			
			if (instanceName == null) {
				instanceNameMatch = true;
			}
			else {
				instanceNameMatch = child.name == instanceName;
			}
			
			if (classNameMatch && instanceNameMatch) {
				result.push( child );
			}
			
			if (child is DisplayObjectContainer) {
				var nested:Array = findChild(DisplayObjectContainer(child), className, instanceName);
				if (nested.length) {
					result = result.concat( nested  );
				}
			}
			  
		}  
		return result;
	}  
} 