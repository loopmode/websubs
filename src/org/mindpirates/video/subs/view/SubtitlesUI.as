package org.mindpirates.video.subs.view
{
	import fl.controls.ComboBox;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	
	import org.mindpirates.video.VideoPlayer;
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.subs.SubtitlesController;
	
	public class SubtitlesUI extends Sprite
	{
		/**
		 * The ComboBox for selecting the subtitles file
		 */
		public var selectBox:SubtitlesSelectionCombo;
		
		/**
		 * holds the value for <code>subtitles</code>
		 * @see #subtitles
		 */
		private var _subtitles:SubtitlesController;
		
		private var _videoPlayer:VideoPlayer;
		
		public function SubtitlesUI(subtitles:SubtitlesController)
		{
			super();
			
			_subtitles = subtitles;
			
			visible = false;
			
			selectBox = new SubtitlesSelectionCombo();
			addChild( selectBox );
			
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
			
		}
		 
		
		/**
		 * Destroys the instance and removes all event listeners.
		 */
		public function destroy():void
		{ 
			removeListeners();
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			removeEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		/**
		 * The <code>Subtitles</code> instance
		 * @see org.mindpirates.video.subs.Subtitles
		 */
		public function get subtitles():SubtitlesController
		{
			return _subtitles;
		}
		
		
		/**
		 * Registers the videoplayer and a PLAYER_READY event listener on it.
		 */ 
		public function setupVideoPlayer(player:VideoPlayer):void
		{ 
			_videoPlayer = player;
			_videoPlayer.addEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady);
		}
		
		public function get videoPlayer():VideoPlayer
		{
			return _videoPlayer;
		}
		
		/*
		--------------------------------------------------------------------------
		
		EVENT LISTENERS
		
		--------------------------------------------------------------------------
		*/
		
		public function handleAdded(event:Event):void
		{
			addListeners();
			removeEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		public function handleRemoved(event:Event):void
		{
			removeListeners();
			addEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		
		public function addListeners():void
		{
			stage.addEventListener(Event.RESIZE, handleStageResize);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullscreenChanged);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
		}
				
		
		public function removeListeners():void
		{
			stage.removeEventListener(Event.RESIZE, handleStageResize);
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, handleFullscreenChanged);
			removeEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
		}
		
		/*
		--------------------------------------------------------------------------
		
		EVENT HANDLERS
		
		--------------------------------------------------------------------------
		*/
		
		public function handlePlayerReady(event:Event):void
		{
			_videoPlayer.removeEventListener(VideoPlayerEvent.PLAYER_READY, handlePlayerReady);
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			visible = true;
			layout();
		}	
		
		public function handleEnterFrame(event:Event):void
		{
			 
		}
		
		public function handleFullscreenChanged(event:FullScreenEvent):void
		{
			layout();
		}		
		
		public function handleStageResize(event:Event):void
		{		
			layout();
		}
		
		/*
		--------------------------------------------------------------------------
		
		LAYOUT
		
		--------------------------------------------------------------------------
		*/
		
		/**
		 * Applies layout to the subtitlesUI. Must be implemented by derived classes to work well with the external videoplayer's UI.
		 */
		public function layout():void
		{ 
		}
		
		
	}
}