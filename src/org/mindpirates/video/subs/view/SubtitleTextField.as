package org.mindpirates.video.subs.view
{
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	/** 
	 * A textfield for displaying subtitles.
	 * @author Jovica Aleksic
	 */
	public class SubtitleTextField extends TextField
	{ 
		private var _fontSize:Number = 10;
		private var _fontName:String;
		public static var defaultFontName:String;
		public static var defaultFontSize:Number;
		
		/**
		 * A textfield for displaying subtitles.
		 * @param config The flashvars passed on from the HTML page
		 */
		public function SubtitleTextField(config:Params)
		{
			super();
			
			defaultFontName = new Font_DejaVu().fontName;
			defaultFontSize = config.fontSize;
			
			_fontName = defaultFontName;
			_fontSize = defaultFontSize;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.align = TextFormatAlign.CENTER; 
			mouseEnabled = false;
			selectable = false;
			embedFonts = true;  
			multiline = true; 
			defaultTextFormat = textFormat;
			antiAliasType = AntiAliasType.ADVANCED;  
			filters = [new DropShadowFilter(2,45,0,0.5,2,2), new GlowFilter(0,1,3,3,4)]; 
			/*
			border = true;
			background = true;
			backgroundColor = 0x222222;
			*/
			 
			wordWrap = true;
			
			updateStyles()    
		}
		public function get fontName():String
		{
			return _fontName;
		}
		private function updateStyles():void
		{
			var _text:String = htmlText;
			
			var ss:StyleSheet = new StyleSheet();
			ss.setStyle('.subtitle', {
				color:'#FFFFFF',
				fontSize: _fontSize,
				fontFamily: fontName
			});
			ss.setStyle('i', {
				color:'#FFFFFF',
				fontSize: _fontSize,
				fontFamily: fontName
			});
			ss.setStyle('strong', {
				color:'#FFFFFF',
				fontSize: _fontSize,
				fontWeight: 'bold',
				fontFamily: fontName,
				display: 'inline'
			});  
			
			styleSheet = ss;	
			
			htmlText = _text;
		}
		public function set fontSize(value:Number):void
		{
			if (value < 1) {
				value = 1;
			}
			_fontSize = value;
			updateStyles();
		}
		public function get fontSize():Number
		{
			return _fontSize;
		}
		private var _scale:Number;
		public function set scale(value:Number):void
		{ 
			_scale = value;
			var matrix:Matrix = transform.matrix; 
			if (value == 1) {
				matrix.identity();				
			} 
			else {
				matrix.scale( value, value );
			}
			transform.matrix = matrix;
		}
		public function get scale():Number
		{
			return _scale;
		}
		public function set font(name:String):void
		{
			_fontName = name;
			trace(this, 'set font', name)
			updateStyles(); 
		}
	}
}