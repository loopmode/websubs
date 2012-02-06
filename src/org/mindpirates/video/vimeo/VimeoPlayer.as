package org.mindpirates.video.vimeo
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.mindpirates.video.IVideoPlayer;
	import org.mindpirates.video.IVideoPlayerUI;
	import org.mindpirates.video.events.VideoPlayerEvent;
	import org.mindpirates.video.subs.VideoServices;
	
	/**
	 * VideoPlayer wrapper class for the Moogaloop player from vimeo.com
	 * 
	 * <h3>Notes:</h3>
	 * <ul>
	 * <li>If the v1 Moogaloop API is used, there is no VIDEO_READY event.</li>
	 * </ul>
	 * @author Jovica Aleksic (jovi@mindpirates.org)
	 */
	public class VimeoPlayer extends VimeoPlayerBase implements IVideoPlayer
	{
		
		/** 
		 * @private
		 * Whether the video is currently playing.
		 * Changed in play(),pause() and stop()
		 */
		private var _isPlaying:Boolean;
		
		/** 
		 * @private
		 * Whether the video is currently paused.
		 * Changed in play(),pause() and stop()
		 */
		private var _isPaused:Boolean;
		
		/**
		 * The IVideoPlayerUI interface for accessing moogaloop's UI elements
		 */
		private var _ui:VimeoPlayerUI;
		
		
		/**
		 * Holds the value of <code>isReady</code>. Will be set to true once the external player is loaded.
		 * @see #isReady
		 */
		private var _isReady:Boolean;
		
		/**
		 * Vimeo Moogaloop implementation of the VideoPlayer class.
		 * @param 
		 */
		public function VimeoPlayer(oauth_key:String, clip_id:String, w:int, h:int, fp_version:String='10', api_version:int=2)
		{
			super(oauth_key, int(clip_id), w, h, fp_version, api_version);
		}
		
		
		override public function get player():Object
		{
			return moogaloop;
		}
		
		override public function get ui():IVideoPlayerUI
		{
			return _ui;
		}
		
		
		/**
		 *  
		 * @copy org.mindpirates.video.vimeo.VimeoPlayerBase.errorHandler()
		 */
		override internal function errorHandler(event:Event):void
		{
			var e:VideoPlayerEvent =  new VideoPlayerEvent( VideoPlayerEvent.ERROR );
			e.originalEvent = event;
			dispatchEvent( e );
		}
		
		
		/**
		 *  
		 * @copy org.mindpirates.video.vimeo.VimeoPlayerBase.playerLoaded()
		 */
		override internal function playerLoaded():void
		{
			_ui = new VimeoPlayerUI( moogaloop as Sprite );
			_isReady = true;
			dispatchEvent( createVideoPlayerEvent( VideoPlayerEvent.PLAYER_READY ) );
		}
	 
		
		/**
		 * 
		 * Moogaloop API v2 Event Handler for READY
		 * @copy org.mindpirates.video.vimeo.VimeoPlayerBase.readyHandler()
		 */
		override internal function readyHandler(event:Event):void
		{
			dispatchEvent( createVideoPlayerEvent( VideoPlayerEvent.VIDEO_READY, event ) );
		}
		
		override public function load(id:String):void
		{
			loadVideo(int(id));
			dispatchEvent( createVideoPlayerEvent( VideoPlayerEvent.LOAD ) );
		}
		
		override public function get videoID():String 
		{
			return String(_clip_id);
		}
		
		/**
		 * 
		 * Moogaloop API v2 Event Handler for LOAD_PROGRESS
		 * @copy org.mindpirates.video.vimeo.VimeoPlayerBase.loadProgressHandler()
		 */
		override internal function loadProgressHandler(event:Event):void
		{
			if (api_version == 2) dispatchEvent( createVideoPlayerEvent( VideoPlayerEvent.LOAD_PROGRESS, event ) );
		}
		
		/**
		 * 
		 * Moogaloop API v1 Event Handler for LOAD_PROGRESS
		 * @copy org.mindpirates.video.vimeo.VimeoPlayerBase.loadProgressHandler()
		 */
		override internal function onLoadingHandler(event:Event):void
		{
			if (api_version == 1) dispatchEvent( createVideoPlayerEvent( VideoPlayerEvent.LOAD_PROGRESS, event ) );
		}

		override public function play() : void
		{
			_isPlaying = true;
			_isPaused = false;
			doPlay();
		}
		
		/**
		 * Moogaloop API v2 Event Handler for PLAY
		 * @copy org.mindpirates.video.vimeo.VimeoPlayerBase.playHandler()
		 */
		override internal function playHandler(event:Event):void
		{
			if (api_version == 2) dispatchEvent( createVideoPlayerEvent( VideoPlayerEvent.PLAY, event ));
		}
		
		/** 
		 * Moogaloop API v1 Event Handler for PLAY
		 * @copy org.mindpirates.video.vimeo.VimeoPlayerBase.playHandler()
		 */
		override internal function onPlayHandler(event:Event):void
		{
			if (api_version == 1) dispatchEvent(createVideoPlayerEvent( VideoPlayerEvent.PLAY, event ));
		}
		
		/** 
		 * Moogaloop API v1 Event Handler for PLAY_PROGRESS
		 * @see org.mindpirates.video.vimeo.VimeoPlayerBase.playProgressHandler() playProgressHandler()
		 */
		override internal function onProgressHandler(event:Event):void
		{
			if (api_version == 1) dispatchEvent(createVideoPlayerEvent( VideoPlayerEvent.PLAY_PROGRESS, event ));
		}
		
		/**
		 * 
		 * Moogaloop API v2 Event Handler for PLAY_PROGRESS.<br>
		 * @copy org.mindpirates.video.vimeo.VimeoPlayerBase.playProgressHandler()
		 */
		override internal function playProgressHandler(event:Event):void
		{
			if (api_version == 2) dispatchEvent( createVideoPlayerEvent( VideoPlayerEvent.PLAY_PROGRESS, event ));
		}
		
		override public function pause() : void
		{
			_isPlaying = false;
			_isPaused = true;
			doPause();
		}
		
		/**
		 * 
		 * Moogaloop API v2 Event Handler for PAUSE
		 * @copy org.mindpirates.video.vimeo.VimeoPlayerBase.pauseHandler()
		 */
		override internal function pauseHandler(event:Event):void
		{
			if (api_version == 2) dispatchEvent(createVideoPlayerEvent( VideoPlayerEvent.PAUSE, event ));
		}
		
		/**
		 * 
		 * Moogaloop API v1 Event Handler for PAUSE
		 * @copy org.mindpirates.video.vimeo.VimeoPlayerBase.pauseHandler()
		 */
		override internal function onPauseHandler(event:Event):void
		{
			if (api_version == 1) dispatchEvent(createVideoPlayerEvent( VideoPlayerEvent.PAUSE, event ));
		}
		 
		override public function stop():void
		{
			_isPlaying = false;
			_isPaused = false;
			doStop();
			dispatchEvent(createVideoPlayerEvent( VideoPlayerEvent.STOP ));
		}

		override public function seekToTime(time:int):void
		{
			seekTo(time/1000);
		}
		
		override public function seekToPercent(percent:int):void
		{
			seekToTime(duration / 100 * percent);
			 
		}
		
		/**
		 * 
		 * Moogaloop API v2 Event Handler for SEEK
		 * @copy org.mindpirates.video.vimeo.VimeoPlayerBase.seekHandler()
		 */
		override internal function seekHandler(event:Event):void
		{
			if (api_version == 2) dispatchEvent(createVideoPlayerEvent( VideoPlayerEvent.SEEK, event ));
		}
		
		/**
		 * 
		 * Moogaloop API v1 Event Handler for SEEK
		 * @copy org.mindpirates.video.vimeo.VimeoPlayerBase.seekHandler()
		 */
		override internal function onSeekHandler(event:Event):void
		{
			if (api_version == 1) dispatchEvent(createVideoPlayerEvent( VideoPlayerEvent.SEEK, event ));
		}
		
		
		override public function get duration():int
		{
			return getDuration()*1000;
		}

		override public function get positionTime():int
		{
			return moogaloop ? moogaloop.getCurrentTime()*1000 : 0;
		}
		
		override public function get positionPercent():Number
		{
			return Math.round(positionTime / duration * 100) / 100;
		}

		/**
		 * @copy org.mindpirates.video.IVideoPlayer#isReady
		 */
		override public function get isReady():Boolean
		{
			return _isReady;
		}
		
		override public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		 
		override public function get isPaused():Boolean
		{
			return _isPaused;
		}
		 
		override public function setSize(w:int, h:int):void
		{
			super.setSize(w, h);
			dispatchEvent(new Event(Event.RESIZE) );
		}
		 
		
	}
}