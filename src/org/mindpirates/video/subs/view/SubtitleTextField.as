package org.mindpirates.video.subs.view
{
	import embed.fonts.EmbeddedFonts;
	
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.mindpirates.video.subs.Subtitles;
	
	import utils.StringUtils;
	
	
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
		 * Holds the value for <code>subs</code>
		 * @see #subs
		 */
		private var _subs:Subtitles;
		
		/**
		 * A textfield for displaying subtitles.
		 * @param config The flashvars passed on from the HTML page
		 */
		public function SubtitleTextField(target:Subtitles)
		{
			super();
			 
			_subs = target;
			 
			defaultFontName = EmbeddedFonts.DejaVu;
			defaultFontSize = subs.main.flashVars.defaultFontSize;
			
			_fontName = defaultFontName;
			_fontSize = defaultFontSize;
			 
			var textFormat:TextFormat = new TextFormat();
			textFormat.align = TextFormatAlign.CENTER; 
			textFormat.color = 0xFFFFFF;
			
			mouseEnabled = false;
			selectable = false;
			embedFonts = true;  
			multiline = true; 
			defaultTextFormat = textFormat;
			antiAliasType = AntiAliasType.ADVANCED;  
			filters = [new DropShadowFilter(2,45,0,0.5,2,2), new GlowFilter(0,1,3,3,4)]; 
			autoSize = TextFieldAutoSize.CENTER;
			/*
			border = true;
			background = true;
			backgroundColor = 0x222222; 
	 		*/
			wordWrap = true;
			
			updateStyles(); 
			
			/*
			var fonts:Array = Font.enumerateFonts(false);
			fonts.sortOn("fontName", Array.CASEINSENSITIVE);
			for each(var f:Font in fonts)
			trace(f.fontName);
			*/
		}
		
		/**
		 * A reference to the <code>Subtitles</code> instance.
		 * @see org.mindpirates.video.subs.Subtitles
		 */
		public function get subs():Subtitles
		{
			return _subs;
		}
		
		
		
		override public function set text(value:String):void
		{ 			
			if (value) {
				visible = true;
				value = '<span class="subtitle">' + 
					value.replace(/\r\n/g,'<br>')
					.replace(/\r/g,'<br>')
					.replace(/\n/g,'<br>')
					.replace(/<b>/g,'<strong>')
					.replace(/<\/b>/g, '</strong>') 
					.replace(/<i>/g,'<em>')
					.replace(/<\/i>/g, '</em>') 
					+ '</span>';
				
				htmlText = StringUtils.removeExtraWhitespace(value); 
				updateStyles();
			} 
			else {
				htmlText = '';
				visible = false;
			}
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
			 
			ss.setStyle('em', {
				color:'#FFFFFF',
				fontSize: _fontSize,  
				fontStyle: 'oblique',
				display: 'inline',
				fontFamily: fontName+' Oblique'
			});
			
			ss.setStyle('strong', {
				color:'#FFFFFF',
				fontSize: _fontSize,
				fontWeight: 'bold',
				fontFamily: fontName+' Bold',
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
			var _txt:String = htmlText;
			htmlText = '';
			
			_fontSize = value;
			updateStyles();
			
			htmlText = _txt;
			
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
		public function set fontName(name:String):void
		{
			_fontName = name;
			updateStyles(); 
		}
		public function get fontName():String
		{
			return _fontName;
		}
	}
}