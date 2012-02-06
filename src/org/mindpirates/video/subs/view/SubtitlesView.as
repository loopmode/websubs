package org.mindpirates.video.subs.view
{
	import flash.display.Sprite;
	
	import org.mindpirates.video.subs.Subtitles;
	
	/**
	 * The <code>SubtitlesView</code> class contains the textfield for displaying subtitles.It takes care of positioning and scaling.
	 */
	public class SubtitlesView extends Sprite
	{
		public var textfield:SubtitleTextField;
		 
		public function SubtitlesView(target:Subtitles)
		{
			super(); 
			 
			textfield = new SubtitleTextField(target);
			addChild(textfield);
			
			textfield.width = target.main.stage.stageWidth - 40; 
			textfield.height = 30;
			textfield.x = 20;
			textfield.y = 20; 
			textfield.text = "#test"
		}
	}
}