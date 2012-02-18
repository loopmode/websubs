package org.mindpirates.video.vimeo
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.mindpirates.video.VideoPlayerBase;
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.subs.Subtitles;
	import org.mindpirates.video.subs.view.SubtitlesUI;

	public class VimeoSubtitlesUI extends SubtitlesUI
	{
		
		/**
		 * Amount of miliseconds for the delay of the <code>layout()</code> call when fullscreen state changes.
		 * @see #handleFullscreenChanged()
		 */
		private const FULLSCREEN_LAYOUT_DELAY:Number = 150;
		
		/**
		 * Cached values for the selectBox position.<br>
		 * Needed to apply positioning correctly when leaving fullscreen state, and the moogaloop UI is not available.
		 */
		private var _initialSelectBoxPosition:Point;
		
		public function VimeoSubtitlesUI(target:Subtitles)
		{
			super(target); 
		}
		 
		
		/*
		--------------------------------------------------------------------------
		
		LAYOUT
		
		--------------------------------------------------------------------------
		*/
		
		/**
		 * Checks the opacity of the moogaloop UI and applies it to itself.<br>
		 * When there was no user input for a while, moogaloop fades out its UI, and our subtitles UI must respond to that.
		 * TODO: Find a good way to apply alpha on the items of the <code>selectBox</code> ComboBox in the subtitles UI without ugly side effects.
		 */
		override public function handleEnterFrame(event:Event):void
		{
			var a:Number = 0;
			if (moogaloop.ui.controlBar && moogaloop.ui.controlBar.alpha) {
				a = moogaloop.ui.controlBar.alpha;
			}
			alpha = a; 
			//subs.view.ui.selectBox.dropdown.alpha = a;
		}
		
		/**
		 * Applies a delayed <code>layout()</code> call based on the <code>FULLSCREEN_LAYOUT_DELAY</code> value.<br>
		 * Moogaloop seems to have a delayed layout function itself, as the UI positions seem incorrect immediatly after the fullscreen event.
		 * @see #FULLSCREEN_LAYOUT_DELAY
		 */
		override public function handleFullscreenChanged(event:FullScreenEvent):void
		{
			visible = false;
			var t:Timer = new Timer(FULLSCREEN_LAYOUT_DELAY, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
				visible = true;
				layout();
			}, false, 0, true);
			t.start();	
		}
		
		override public function layout():void
		{
			super.layout();
			
			// set the comboBox position right above moogaloop's play button
			try {
				selectBox.x = moogaloop.ui.controlBar.x + moogaloop.ui.playPauseButton.x;
				selectBox.y = moogaloop.ui.playPauseButton.y - selectBox.height - 5;
			}
			catch (err:Error) {
				// when leaving fullscreen mode, an error is thrown when trying to access moogaloop's UI elements.
				// therefore, we use cached values of the position
				if (_initialSelectBoxPosition) {
					selectBox.x = _initialSelectBoxPosition.x;
					selectBox.y = _initialSelectBoxPosition.y;
				}
			}
			
			if (!_initialSelectBoxPosition) {
				_initialSelectBoxPosition = new Point(selectBox.x, selectBox.y);
			}
		}
		
		/*
		--------------------------------------------------------------------------
		
		VIDEOPLAYER
		
		--------------------------------------------------------------------------
		*/
		 
		/**
		 * A Reference to the videoplayer casted as <code>VimeoPlayer</code>
		 * @see org.mindpirates.video.vimeo.VimeoPlayer
		 */
		public function get moogaloop():VimeoPlayer
		{
			return subs.main.videoPlayer as VimeoPlayer
		}
		 
	}
}