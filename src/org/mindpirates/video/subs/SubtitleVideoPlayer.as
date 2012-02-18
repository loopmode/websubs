package org.mindpirates.video.subs
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point; 
	
	import net.stevensacks.preloaders.CircleSlicePreloader;
	
	import org.mindpirates.video.VideoPlayerBase;
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.vimeo.VimeoAuth;
	import org.mindpirates.video.vimeo.VimeoPlayer;
	
	/**
	 * Dispatched when the player has been loaded.
	 * @eventType org.mindpirates.video.events.VideoPlayerEvent
	 */
	[Event(name="lineChanged", type="org.mindpirates.video.events.SubtitleEvent")]
	
	/**
	 * The <code>SubtitleVideoPlayer</code> class adds subtitle support to a videoplayer class.<br>
	 * @see #videoPlayer videoPlayer
	 * @author Jovica Aleksic
	 */
	public class SubtitleVideoPlayer extends Sprite
	{
		
		/**
		 * The flashvars passed from the HTML page.
		 */
		public var flashVars:FlashVars;
		
		/**
		 * The VideoPlayer instance.
		 * @see org.mindpirates.video.VideoPlayerBase
		 */
		public var videoPlayer:VideoPlayerBase;
		
		/**
		 * The Subtitles instance.
		 * @see org.mindpirates.video.subs.Subtitles
		 */
		private var subs:Subtitles;
		
		/**
		 * The spinner shown while the videoPlayer is loading
		 */
		private var spinner:CircleSlicePreloader;
		
		/**
		 * The name of the video service. Must be a value defined in <code>VideoServices</code>.
		 * @see org.mindpirates.video.subs.VideoServices
		 */
		private var _videoServiceName:String;
		
		/**
		 * The initial size of the stage at startup. This is the size at which the player was originally embedded into the HTML page.<br>
		 * The variable type is <code>Point</code>. The <code>x</code> value contains the <code>stage.stageWidth</code> value, and the <code>y</code> value contains the <code>stage.stageHeight</code> value.
		 */
		public var initialSize:Point;
		
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
		
		VIDEO SERVICE
		
		--------------------------------------------------------------------------
		*/
		
		public function setVideoService(name:String):void
		{
			_videoServiceName = name;
		}
		public function get videoServiceName():String
		{
			return _videoServiceName;
		}
		
		/*
		--------------------------------------------------------------------------
		
			EVENT LISTENERS
		
		--------------------------------------------------------------------------
		*/
		
		protected function handleAdded(event:Event):void
		{
			initialSize = new Point(stage.stageWidth,stage.stageHeight);
			setupStage();
			showSpinner();
			createPlayer();
			createSubtitles();
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
		 
		
		public function get currentScale():Number
		{
			return stage.stageWidth / initialSize.x ;
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
		
		private function createSubtitles():void
		{
			 subs = new Subtitles(this);
		}
		
		private function destroySubtitlesViewer():void
		{
			subs.destroy();
			subs = null;
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