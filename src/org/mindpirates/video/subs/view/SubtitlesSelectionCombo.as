package org.mindpirates.video.subs.view
{
	import embed.Fonts;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.mindpirates.video.subs.loading.SubtitleFileLoader;
	
	public class SubtitlesSelectionCombo extends ComboBox
	{
		public function SubtitlesSelectionCombo()
		{
			super();
		}
		
		private function setupStyles():void
		{
			setStyle('textPadding', 2); 
			
			var format:TextFormat = new TextFormat()
			format.color = 0xFFFFFF; 
			format.font = Fonts.UNI_05_53;
			format.size = 8;
			
			dropdown.setRendererStyle("embedFonts", true);
			dropdown.setRendererStyle("textFormat", format);
			dropdown.setRendererStyle("antiAliasType", AntiAliasType.NORMAL);
			
			textField.setStyle("embedFonts", true); 
			textField.setStyle("textFormat", format);
			textField.setStyle("antiAliasType", AntiAliasType.NORMAL);
			textField.textField.autoSize = TextFieldAutoSize.LEFT;
		}
		 	 
		override public function set dataProvider(arg0:DataProvider):void
		{
			super.dataProvider = arg0;
			rowCount = arg0.length;
			selectedIndex = 0;
			setupStyles();
		}
		
		public function createDataProvider(files:Vector.<SubtitleFileLoader>):DataProvider
		{
			var dp:Array = [];
			for each (var file:SubtitleFileLoader in files) {
				dp.push({
					label: file.title,
					title: file.title,
					fileLoader: file
				}); 
			}
			return new DataProvider(dp);
		}
	}
}