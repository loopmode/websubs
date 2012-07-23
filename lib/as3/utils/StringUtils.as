package utils {
	
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
		
		/**
		 * Returns the part of a string after the last occurance of a slash.
		 */
		public static function getFileName(value:String):String
		{
			if (value.indexOf('/') == -1) {
				return value;
			}
			return value.substr(value.lastIndexOf('/')+1, value.length);
		}
		
	 

		/**
		 * returns a videoplayer time format (HH:MM:SS:MS) from milliseconds
		 */
		public static function videoTime(value:Number):String //example value in mis: 1000
		{
			//value = value * 1000; // convert video currentTime 1.000 to 1000
			
			var milliseconds:Number  = Math.round(((value/1000) % 1) * 1000);
			var seconds:Number  = Math.floor((value/1000) % 60);
			var minutes:Number  = Math.floor((value/60000) % 60);
			var hours:Number  = Math.floor((value/3600000) % 24);
			
			var s_miliseconds:String     = (milliseconds<10 ? "00" : (milliseconds<100 ? "0" : ""))+ String(milliseconds);
			var s_seconds:String     = seconds < 10 ? "0" + String(seconds) : String(seconds); 
			var s_minutes:String     = minutes < 10 ? "0" + String(minutes) : String(minutes); 
			var s_hours:String     = hours < 10 ? "0" + String(hours) : String(hours);
			
			return s_hours  + ":" + s_minutes  + ":" + s_seconds + '.'+s_miliseconds;
			
		}

		/**
		 * Add a number of leading zeroes in front of a string.
		 * totalDigits specifies the total number of characters you want to see
		 * in the returned string.
		 * @link http://www.untoldentertainment.com/blog/2009/04/14/as3-helper-class-pad-string-with-zeroes/
		 * @example
		 * var paddedNumber:String = Helper.PadStringWithZeroes(String(5), 4); // returns "0005"
		 */	
		public static function PadStringWithZeroes(string:String, totalDigits:uint):String
		{
			var zeroString:String = "";
			for (var i:uint = 0; i < totalDigits - string.length; i++)
			{
				zeroString += "0";
			}
			return zeroString + string;
		}
		
	}
}