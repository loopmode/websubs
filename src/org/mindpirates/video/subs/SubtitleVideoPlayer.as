package org.mindpirates.video.subs
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import net.stevensacks.preloaders.CircleSlicePreloader;
	
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.vimeo.VimeoAuth;
	import org.mindpirates.video.vimeo.VimeoPlayer;
	import org.mindpirates.video.FlashVars;
	import org.mindpirates.video.VideoPlayer;
	import org.mindpirates.video.VideoServices;
	
	[SWF(width="640", height="360", bgColor="0x000000")]
	/**
	 * Wrapper class for vimeo.com videos with support for SRT subtitles.
	 * Youtube and different subtitle formats are considered.
	 * @author Jovica Aleksic (jovi@mindpirates.org)
	 */
	public class SubtitleVideoPlayer extends Sprite
	{
		
		/**
		 * The flashvars passed from the HTML page.
		 */
		public var flashVars:FlashVars;
		
		/**
		 * The VideoPlayer instance.
		 * @see org.mindpirates.video.VideoPlayer
		 */
		public var videoPlayer:VideoPlayer;
		
		/**
		 * The SubtitlesViewer instance.
		 * @see org.mindpirates.video.srtplayer.SubtitlesViewer
		 */
		private var subtitlesViewer:SubtitlesController;
		
		/**
		 * The spinner shown while the videoPlayer is loading
		 */
		private var spinner:CircleSlicePreloader;
		
		public function SubtitleVideoPlayer()
		{
			super();
			flashVars = new FlashVars(loaderInfo.parameters);
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		public function destroy():void
		{
			destroyPlayer();
			destroySubtitlesViewer();
		}
		
		/*
		--------------------------------------------------------------------------
		
			EVENT LISTENERS
		
		--------------------------------------------------------------------------
		*/
		
		protected function handleAdded(event:Event):void
		{
			setupStage();
			showSpinner();
			createPlayer();
			createSubtitlesViewer();
			addListeners();
		}
			
		
		protected function handleRemoved(event:Event):void
		{
			removeListeners();
			destroyPlayer();
		}
			
		/**
		 * Adds all neccessary event listeners. 
		 */
		private function addListeners():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, handleAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
			stage.addEventListener(Event.RESIZE, handleResize); 
		}
		
		/**
		 * Removes all registered event listeners.
		 * Adds an event listener for ADDED_TO_STAGE to run <code>addListeners()</code> again.
		 */
		private function removeListeners():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
			stage.removeEventListener(Event.RESIZE, handleResize); 
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		/*
		--------------------------------------------------------------------------
		
		EVENT HANDLERS
		
		--------------------------------------------------------------------------
		*/
		
		protected function handleResize(event:Event):void
		{ 	
			videoPlayer.setSize(stage.stageWidth, stage.stageHeight);
		}
		 
		/*
		--------------------------------------------------------------------------
		
		VIDEO PLAYER
		
		--------------------------------------------------------------------------
		*/
		
		/**
		 * Creates the videoplayer instance. Needs to be implemented by derived class.
		 */
		public function createPlayer():void
		{  
			// videoPlayer must be created in derived class
			videoPlayer.addEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady); 
		}
		 
		
		protected function handlePlayerReady(event:Event):void
		{
			videoPlayer.removeEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady);
			hideSpinner();
		}
		
		private function destroyPlayer():void
		{
			videoPlayer.destroy();
			removeChild(videoPlayer.displayObject);
			videoPlayer = null;
		}	
		
		
		/*
		--------------------------------------------------------------------------
		
		SUBTITLES DISPLAY
		
		--------------------------------------------------------------------------
		*/
		
		private function createSubtitlesViewer():void
		{
			 subtitlesViewer = new SubtitlesController(flashVars);
			 subtitlesViewer.setVideoPlayer( videoPlayer );
		}
		
		private function destroySubtitlesViewer():void
		{
			subtitlesViewer.destroy();
			subtitlesViewer = null;
		}
		
		
		/*
		--------------------------------------------------------------------------
		
		SPINNER
		
		--------------------------------------------------------------------------
		*/
		
		/**
		 * Creates and adds a loading animation centered on the screen.
		 */
		public function showSpinner():void
		{
			spinner = new CircleSlicePreloader();
			spinner.x = 0.5 * stage.stageWidth;
			spinner.y = 0.5 * stage.stageHeight;
			addChild(spinner);
		}		
		
		/**
		 * Removes the spinner.
		 * @see #createSpinner()
		 */
		public function hideSpinner():void
		{ 
			removeChild(spinner);
			spinner.destroy();
			spinner = null;
		}	
		
		/*
		--------------------------------------------------------------------------
		
		MISC FUNCTIONS
		
		--------------------------------------------------------------------------
		*/
		
		/**
		 * Sets up alignment and scaling for the stage.
		 */
		private function setupStage():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
	}
}