package org.mindpirates.video.vimeo
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.describeType;
	
	import org.mindpirates.video.IVideoPlayerUI;
	
	public class VimeoPlayerUI implements IVideoPlayerUI
	{
		private var moogaloop:Sprite;
		
		public function VimeoPlayerUI(player:Sprite)
		{
			moogaloop = player; 
		}
		 
		public function get controlBar():Sprite
		{
			return findChild(moogaloop, 'VideoControlsView')[0] as Sprite;
		}
		
		public function get playPauseButton():DisplayObject
		{
			return findChild(moogaloop, 'PlayPauseButton')[0];
		}
		
		public function get hdButton():DisplayObject
		{
			return findChild(moogaloop, 'HDButton')[0];
		}
		
		internal function get hdIcon():Sprite
		{ 
			return findChild(DisplayObjectContainer(hdButton), 'HDIcon_SVGClass')[0]
		}
		
		public function get fullscreenButton():DisplayObject
		{
			return findChild(moogaloop, 'FullscreenButton')[0];
		}
		
		public function get seekSlider():DisplayObject
		{
			return null;
		}
		
		public function get volumeSlider():DisplayObject
		{
			return null;
		}
	}
}