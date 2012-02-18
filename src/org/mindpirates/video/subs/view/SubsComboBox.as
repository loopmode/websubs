package org.mindpirates.video.subs.view
{
	import embed.Fonts;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.mindpirates.video.subs.loading.SubsFileLoader;
	
	public class SubsComboBox extends ComboBox
	{
		public function SubsComboBox()
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
		
		public function createDataProvider(files:Vector.<SubsFileLoader>):DataProvider
		{
			var dp:Array = [];
			for each (var file:SubsFileLoader in files) {
				dp.push({
					label: file.title,
					title: file.title,
					fileLoader: file
				}); 
			}
			return new DataProvider(dp);
		}
		
		
		/**
		 * Returns the index of an item based on the fileLoader reference.
		 * @param fileLoader The fileLoader of the searched list item.
		 * @return The index of the item within the dataProvider or -1 if no match was found.
		 */ 
		public function getFileIndex(fileLoader:SubsFileLoader):int
		{ 
			var i:int = 0;
			while (i<dataProvider.length) {
				if (dataProvider.getItemAt(i).fileLoader == fileLoader) {
					return i;
				}
				i++;
			}
			return -1;
		}
	}
}