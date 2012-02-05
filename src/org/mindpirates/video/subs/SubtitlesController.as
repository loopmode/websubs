package org.mindpirates.video.subs
{
	import embed.Fonts;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.utils.Timer;
	
	import org.mindpirates.video.VideoPlayer;
	import org.mindpirates.video.VideoServices;
	import org.mindpirates.video.events.SubtitleListEvent;
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.subs.loading.SubtitleFileLoader;
	import org.mindpirates.video.subs.loading.SubtitlesListLoader;
	import org.mindpirates.video.subs.view.SubtitlesUI;
	import org.mindpirates.video.vimeo.VimeoSubtitlesUI;
	
	/**
	 * This class displays subtitles for a videoPlayer.<br> 
	 * It is the master component for all subtitles-related actions.
	 */
	public class SubtitlesController extends EventDispatcher
	{
		 
		/**
		 * The target video player.
		 */
		private var _videoPlayer:VideoPlayer;
		
		/**
		 * The URLLoader that loads the subtitles file.
		 */
		private var loader:URLLoader;
		
		/**
		 * URL of the currently loaded subtitles file.
		 */
		private var _currentSubtitleFile:String;
		
		/**
		 * @copy org.mindpirates.video.subs.SubtitleVideoPlayer#flashVars
		 */
		public var flashVars:FlashVars;
		
		/**
		 * The SubtitlesList that loads the XML file containing paths to individual subtitle files.
		 */
		private var subtitlesList:SubtitlesListLoader;

		/**
		 * A Sprite that holds required UI elements.
		 */
		private var ui:SubtitlesUI;
		 
		
		/**
		 * Embeds the required fonts.
		 * @see org.mindpirates.video.subs.Fonts
		 */
		public static var fonts:Fonts = new Fonts();
		
		/*
		-------------------------------------------------------------------------------------
		
		CONSTRUCT / DESTROY
		
		-------------------------------------------------------------------------------------
		*/
		
		/**
		 * The timer for updating the subtitles
		 */
		private var timer:Timer;
		
		/**
		 * Amount of miliseconds for the update timer interval.
		 */
		public static const TIMER_INTERVAL:int = 40;
		
		/**
		 * @param vars The flashvars passed from the HTML page
		 */
		public function SubtitlesController(vars:FlashVars)
		{
			super(); 
			flashVars = vars;
			createView();
			loadSubtitlesList( flashVars.subtitlesList );
		}
		
		
		/**
		 * Destroys the instance and cleans up. Removes event listeners.
		 */
		public function destroy():void
		{
			if (videoPlayer) removePlayerEvents();
			ui.destroy();
		}
		
		/*
		-------------------------------------------------------------------------------------
		
		VIEW
		
		-------------------------------------------------------------------------------------
		*/
		 
		
		private function createView():void
		{
			// UI
			switch (flashVars.video_service) {
				case VideoServices.VIMEO:
					ui = new VimeoSubtitlesUI(this);
			}
			ui.selectBox.addEventListener(Event.CHANGE, handleSelectFileChange);
			
		}
		
		/*
		-------------------------------------------------------------------------------------
		
		LOADING
		
		-------------------------------------------------------------------------------------
		*/
		
		public function loadSubtitlesList(file:String):void
		{
			if (!file) {
				return;
			}
			subtitlesList = new SubtitlesListLoader();
			subtitlesList.addEventListener(SubtitleListEvent.LOAD_COMPLETE, handleSubtitlesListComplete);
			subtitlesList.load(new URLRequest(file+'?time='+new Date().time));
		}
		
		protected function handleSubtitlesListComplete(event:Event):void
		{
			subtitlesList.removeEventListener(SubtitleListEvent.LOAD_COMPLETE, handleSubtitlesListComplete);
			ui.selectBox.dataProvider = ui.selectBox.createDataProvider(subtitlesList.files);
		}		
		
		protected function handleSelectFileChange(event:Event):void
		{
			var fileLoader:SubtitleFileLoader = ui.selectBox.selectedItem.fileLoader;
			if (!fileLoader.isLoaded) {
				fileLoader.addEventListener(Event.COMPLETE, handleSubtitleFileLoaded);
				fileLoader.load();
			}
			else {
				displaySelectedSubtitles();
			}
		}
		
		protected function handleSubtitleFileLoaded(event:Event):void
		{
			displaySelectedSubtitles();
		}
		
		private function displaySelectedSubtitles():void
		{
			var file:SubtitleFileLoader = ui.selectBox.selectedItem.fileLoader;
			
		}
		
		/*
		-------------------------------------------------------------------------------------
		
		VIDEOPLAYER
		
		-------------------------------------------------------------------------------------
		*/
		
		/**
		 * Sets the target video player and registers event listeners.<br>
		 * If a videoplayer was set previously, event listeners are removed from it.
		 */
		public function setVideoPlayer(videoplayer:VideoPlayer):void
		{
			if (_videoPlayer) removePlayerEvents();
			
			if (!videoplayer) {
				return;
			}
			
			_videoPlayer = videoplayer;
			_videoPlayer.parent.addChild(ui);
			addPlayerEvents();
			
			createTimer();
			ui.setupVideoPlayer(_videoPlayer);
		}
		 
		/**
		 * Public getter for the target videoPlayer.
		 */
		public function get videoPlayer():VideoPlayer
		{
			return _videoPlayer;
		}
		
		
		/*
		-------------------------------------------------------------------------------------
		
		TIMER
		
		-------------------------------------------------------------------------------------
		*/
		
		/**
		 * Creates the <code>timer</code> and registers the <code>TimerEvent.TIMER</code> event listener.
		 * @see #timer
		 */
		private function createTimer():void
		{
			if (timer) {
				destroyTimer();
			}
			timer = new Timer( TIMER_INTERVAL );
			timer.addEventListener(TimerEvent.TIMER, handleTimer);
		}
		
		/**
		 * Destroys the <code>timer</code> and removes the <code>TimerEvent.TIMER</code> event listener.
		 */
		private function destroyTimer():void
		{
			if (!timer) {
				return;
			}
			timer.removeEventListener(TimerEvent.TIMER, handleTimer);
			timer = null;
		}
		
		
		protected function handleTimer(event:TimerEvent):void
		{
			trace(videoPlayer.positionTime, videoPlayer.duration, videoPlayer.positionPercent);
		}
		
		
		/*
		-------------------------------------------------------------------------------------
		
			VIDEOPLAYER EVENTS
		
		-------------------------------------------------------------------------------------
		*/
		
		/**
		 * Registers all neccessary event listeners on the target videoPlayer.<br>
		 * Registered events:
		 * <ul>
		 * <li>LOAD</li>
		 * <li>PLAY</li>
		 * <li>PAUSE</li>
		 * <li>STOP</li>
		 * <li>SEEK</li>
		 * </ul>
		 */
		private function addPlayerEvents():void
		{
			videoPlayer.addEventListener(VideoPlayerEvent.PLAY, handlePlayVideo);
			videoPlayer.addEventListener(VideoPlayerEvent.PAUSE, handlePauseVideo);
			videoPlayer.addEventListener(VideoPlayerEvent.STOP, handleStopVideo);
			videoPlayer.addEventListener(VideoPlayerEvent.SEEK, handleSeekVideo);
		}
		
		/**
		 * Removes all registered events from the target videoPlayer.
		 */
		private function removePlayerEvents():void
		{
			videoPlayer.removeEventListener(VideoPlayerEvent.PLAY, handlePlayVideo);
			videoPlayer.removeEventListener(VideoPlayerEvent.PAUSE, handlePauseVideo);
			videoPlayer.removeEventListener(VideoPlayerEvent.STOP, handleStopVideo);
			videoPlayer.removeEventListener(VideoPlayerEvent.SEEK, handleSeekVideo);
		}
		
		protected function handlePlayVideo(event:Event):void
		{
			timer.start();			
		}
		
		protected function handlePauseVideo(event:Event):void
		{
			timer.stop();
		}
		
		protected function handleStopVideo(event:Event):void
		{
			timer.stop();
		}
		
		protected function handleSeekVideo(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		
		
	}
}