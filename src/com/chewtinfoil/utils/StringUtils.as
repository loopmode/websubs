package com.chewtinfoil.utils {
	
	/**
	 * 	String Utilities class by Ryan Matsikas, Feb 10 2006
	 *
	 *	Visit www.gskinner.com for documentation, updates and more free code.
	 * 	You may distribute this code freely, as long as this comment block remains intact.
	 */
	/**
	 * edited by Jovica Aleksic: removed most functions except ones used in VimeoSrtPlayer
	 */
	
	public class StringUtils {
		 
		/**
		 *	Removes extraneous whitespace (extra spaces, tabs, line breaks, etc) from the
		 *	specified string.
		 *
		 *	@param p_string The String whose extraneous whitespace will be removed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function removeExtraWhitespace(p_string:String):String {
			if (p_string == null) { return ''; }
			var str:String = trim(p_string);
			return str.replace(/\s+/g, ' ');
		}
		 
		/**
		 *	Removes whitespace from the front and the end of the specified
		 *	string.
		 *
		 *	@param p_string The String whose beginning and ending whitespace will
		 *	will be removed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function trim(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/^\s+|\s+$/g, '');
		}
		 
		
	}
}