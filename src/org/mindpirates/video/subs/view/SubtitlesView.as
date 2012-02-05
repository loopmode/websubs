package org.mindpirates.video.subs.view
{
	import flash.display.Sprite;
	import org.mindpirates.video.subs.SubtitlesController;
	
	
	public class SubtitlesView extends Sprite
	{
		public var textfield:SubtitleTextField;
		
		/**
		 * The <code>SubtitlesComponent</code> instance
		 * @see org.mindpirates.video.subs.SubtitlesComponent
		 */
		private var subtitleComponent:SubtitlesController;
		
		public function SubtitlesView(subtitles:SubtitlesController)
		{
			super();
			subtitleComponent = subtitles;
			
			textfield = new SubtitleTextField(subtitleComponent.flashVars);
			addChild(textfield);
			
		}
	}
}