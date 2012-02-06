package org.mindpirates.video.subs {
	
	/**
	 *	@author Jankees.van.Woezik
	 */
	public class SubtitleParser {
		public static function parseSRT(data : String) : Array {
			var result : Array = new Array();
			
			var lines : Array;
			var subtitleLine : SubtitleLine;
			
			var blocks : Array = data.split(/^[0-9]+$/gm);
			for each (var block : String in blocks) {
				subtitleLine = new SubtitleLine();
				lines = block.split('\n');
				for each (var line : String in lines) { 
					//trace('parse: '+line);
					//all lines in a translation block
					if(trim(line) != "") {
						if(line.match("-->")) { 
							//timecodes line
							var timecodes : Array = line.split(/[ ]+-->[ ]+/gm);
							if(timecodes.length != 2) {
								trace("Translation error, something wrong with the start or end time");							
							} else {
								
								subtitleLine.start = stringToSeconds(timecodes[0]);
								subtitleLine.end = stringToSeconds(timecodes[1]);  
							}
						} else { 
							//translation line
							if(subtitleLine.text.length != 0) line = "\n" + trim(line);
							subtitleLine.text += line;
						}
					}
				}
				result.push(subtitleLine);
			}		

			// remove empty first line
			subtitleLine = result[0];
			if (subtitleLine.start == 0 && subtitleLine.end == 0 && !subtitleLine.text) {
				result.shift();
			}
			return result;
		}
		
		public static function trim(p_string : String) : String {
			if (p_string == null) { 
				return ''; 
			}
			return p_string.replace(/^\s+|\s+$/g, '');
		}
		
		/**
		 * Convert a string to seconds, with these formats supported:
		 * 00:03:00.1 / 03:00.1 / 180.1s / 3.2m / 3.2h / 00:01:53,800
		 * 
		 * Special thanks to Thijs Broerse of Media Monks!
		 * 
		 **/
		public static function stringToSeconds(string : String) : Number {
			var arr : Array = string.split(':');
			var sec : Number = 0;
			if (string.substr(-1) == 's') {
				sec = Number(string.substr(0, string.length - 1));
			}else if (string.substr(-1) == 'm') {
				sec = Number(string.substr(0, string.length - 1)) * 60;
			}else if(string.substr(-1) == 'h') {
				sec = Number(string.substr(0, string.length - 1)) * 3600;
			}else if(arr.length > 1) {
				if(arr[2] && String(arr[2]).indexOf(',') != -1) arr[2] = String(arr[2]).replace(/\,/, ".");
				
				sec = Number(arr[arr.length - 1]);
				sec += Number(arr[arr.length - 2]) * 60;
				if(arr.length == 3) {
					sec += Number(arr[arr.length - 3]) * 3600;
				}
			} else {
				sec = Number(string);
			}
			return sec;
		}
	}
}