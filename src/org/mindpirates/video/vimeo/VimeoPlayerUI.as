package org.mindpirates.video.vimeo
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.describeType;
	
	import org.mindpirates.video.IVideoPlayerUI;
	
	public class VimeoPlayerUI implements IVideoPlayerUI
	{
		private var moogaloop:Sprite;
		
		public function VimeoPlayerUI(player:Sprite)
		{
			moogaloop = player; 
		}
		
		 
		public function findChild(target:DisplayObjectContainer, className:String):DisplayObject
		{
			var i:int=0;
			var result:DisplayObject;
			while (i<target.numChildren) {
				if (!result) {
					if (target.getChildAt(i).toString() == '[object '+className+']') {
						result = target.getChildAt(i) as Sprite;
					}
					else {
						var container:DisplayObjectContainer = target.getChildAt(i) as DisplayObjectContainer;
						if (container && !result) {
							result = findChild(container, className);
						}
					}
				}
				i++;
			}
			return result;
		}
		 
		public function get controlBar():Sprite
		{
			return findChild(moogaloop, 'VideoControlsView') as Sprite;
		}
		
		public function get playPauseButton():DisplayObject
		{
			return findChild(moogaloop, 'PlayPauseButton');
		}
		
		public function get fullscreenButton():DisplayObject
		{
			return null;
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