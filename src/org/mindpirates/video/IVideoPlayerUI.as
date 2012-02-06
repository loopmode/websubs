package org.mindpirates.video
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * The IVideoPlayerUI interface specifies getter functions for access to the UI elements of an externally loaded videoplayer (e.g. Vimeo/Moogaloop)
	 */
	public interface IVideoPlayerUI
	{
		function get controlBar():Sprite;
		function get playPauseButton():DisplayObject;
		function get fullscreenButton():DisplayObject;
		function get seekSlider():DisplayObject;
		function get volumeSlider():DisplayObject;
	}
}