package org.mindpirates.video.subs
{

	import utils.StringUtils;
	
	import flash.system.System;
	 
	 

	/** 
	 * @author Jovica Aleksic
	 */
	public class SubtitlesFileData
	{
		private var _data:Array;
		private var start_positions:Array;
		public var url:String;
		public function SubtitlesFileData(data:Array, src:String)
		{ 
			_data = data; 
			url = src;
		} 
		public function get list():Array
		{
			return _data;
		}
		
		
		public function getLineAt(index:int):SubtitleLine
		{
			return _data[index];
		}
		
		
		public function getLineIndex(value:SubtitleLine):int
		{
			//trace('getLineIndex()', value);
			var result:int = -1; 
			for (var i:int=0,t:int=_data.length; i<t; i++)  {
				//trace('-->', _data[i].start, value.start,_data[i].end, value.end )
				if (_data[i].start == value.start && _data[i].end == value.end) {
					result = i;
				}
			}
			//trace('--> '+result);
			return result;
			
		}
		
		public function getLineIndexByText(value:String):int
		{
			var result:int = -1; 
			for (var i:int=0,t:int=_data.length; i<t; i++) 
			{
				var line:SubtitleLine = _data[i];
				if (line.text == value) {
					result = i;
				}
			}
			return result;
		}

		// TODO Specify and document the format of the time argument.
		/**
		 * Returns the subtitle line for a given time position.
		 * @param time 
		 * @return A <code>SubtitleLine</code> object or null
		 * @see org.mindpirates.video.subs.SubtitleLine
		 */
		public function getLineAtTime(time:Number):SubtitleLine
		{ 
			//trace('getLineAtTime('+time+')')
			time = time/1000;
			var result:SubtitleLine; 
			for (var i:int=0,t:int=_data.length; i<t; i++) 
			{
				var line:SubtitleLine = _data[i];
				//trace('line.start: '+line.start+', line.end: '+line.start);
				if (line.start <= time && line.end >= time) {
					result = line;
				}
			}
			//trace('--> '+result);
			return result;
		}
		
		/**
		 * Creates a JSON String of all the subtitle lines
		 */
		public function toJson():String
		{
			var result:Object = {
				src: url,
				lines: []
			} 
			for (var i:int=0,t:int=_data.length; i<t; i++) 
			{
				var line:SubtitleLine = _data[i];
				var resultObj:Object = {
					text: StringUtils.removeExtraWhitespace(line.text),
					start: line.start,
					end: line.end
				}
				result.lines.push( resultObj );  
			}
			return JSON.stringify(result);
		}
		
		public function replaceLine(oldLine:SubtitleLine, newline:SubtitleLine):void
		{
			
		}
	}
}