package org.mindpirates.video
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.mindpirates.video.events.VideoPlayerEvent;
	
	/**
	 * Dispatched when the player has been loaded.
	 * @eventType org.mindpirates.video.events.VideoPlayerEvent
	 */
	[Event(name="playerReady", type="org.mindpirates.video.events.VideoPlayerEvent")]
	
	/** 
	 * Dispatched when a new video is loaded.
	 * @eventType org.mindpirates.video.events.VideoPlayerEvent
	 */
	[Event(name="load", type="org.mindpirates.video.events.VideoPlayerEvent")]
	
	/** 
	 * Note: Data properties apply to the <code>originalEvent</code> property!
	 * @copy org.mindpirates.video.vimeo.VimeoPlayerBase#loadProgressHandler() 
	 * @eventType org.mindpirates.video.events.VideoPlayerEvent
	 */
	[Event(name="loadProgress", type="org.mindpirates.video.events.VideoPlayerEvent")]
	
	/**
	 * Dispatched when the loaded video is ready for playback.
	 * @eventType org.mindpirates.video.events.VideoPlayerEvent
	 */
	[Event(name="videoReady", type="org.mindpirates.video.events.VideoPlayerEvent")]
	
	/**
	 * Dispatched when playback has started.
	 * @eventType org.mindpirates.video.events.VideoPlayerEvent
	 */
	[Event(name="play", type="org.mindpirates.video.events.VideoPlayerEvent")]
	
	/** 
	 * Note: Data properties apply to the <code>originalEvent</code> property!
	 * @copy org.mindpirates.video.vimeo.VimeoPlayerBase#playProgressHandler() 
	 * @eventType org.mindpirates.video.events.VideoPlayerEvent
	 */
	[Event(name="playProgress", type="org.mindpirates.video.events.VideoPlayerEvent")]
	
	/**
	 * Dispatched when playback has been seeked to a new position.
	 * @eventType org.mindpirates.video.events.VideoPlayerEvent
	 */
	[Event(name="seek", type="org.mindpirates.video.events.VideoPlayerEvent")]
	
	/**
	 * Dispatched when playback has been paused.
	 * @eventType org.mindpirates.video.events.VideoPlayerEvent
	 */
	[Event(name="pause", type="org.mindpirates.video.events.VideoPlayerEvent")]
	
	/**
	 * Dispatched when playback has been stopped.
	 * @eventType org.mindpirates.video.events.VideoPlayerEvent
	 */
	[Event(name="stop", type="org.mindpirates.video.events.VideoPlayerEvent")]
	
	/**
	 * Dispatched when the size has been changed usind <code>setSize()</code>.
	 * @eventType org.mindpirates.video.events.VideoPlayerEvent
	 */
	[Event(name="resize", type="flash.events.Event")]
	
	/**
	 * Dispatched when an error occured in the player.
	 * @eventType org.mindpirates.video.events.VideoPlayerEvent
	 */
	[Event(name="error", type="org.mindpirates.video.events.VideoPlayerEvent")]
	
	/**
	 * Videoplayer class skeleton.
	 * Base class for videoplayers. Implements IVideoPlayer and defines documented Events for the Flash Builder IDE.<br>
	 * Derived classes should override the functions and implement their actual functionality.
	 * @author Jovica Aleksic (jovi@mindpirates.org)
	 */
	public class VideoPlayer extends Sprite implements IVideoPlayer
	{
		public function VideoPlayer()
		{
			super();
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#displayObject 
		 */
		public function get displayObject():DisplayObject
		{
			return this as DisplayObject;
		}
		
		
		public function destroy():void
		{
			// must be implemented by derived classes
		}
		
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#player 
		 */
		public function get player():Object
		{
			// must be implemented by derived classes
			return null;
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#ui 
		 */
		public function get ui():IVideoPlayerUI
		{
			// must be implemented by derived classes
			return null;
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#load() 
		 */
		public function load(id:String):void
		{
			// must be implemented by derived classes
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#videoID 
		 */
		public function get videoID():String
		{
			// must be implemented by derived classes
			return null;
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#play() 
		 */
		public function play():void
		{
			// must be implemented by derived classes
		}
		
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#pause()
		 */
		public function pause():void
		{
			// must be implemented by derived classes
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#stop()
		 */
		public function stop():void
		{
			// must be implemented by derived classes
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#seekToTime()
		 */
		public function seekToTime(time:int):void
		{
			// must be implemented by derived classes
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#seekToPercent()
		 */
		public function seekToPercent(percent:int):void
		{
			// must be implemented by derived classes
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#setSize()
		 */
		public function setSize(w:int, h:int):void
		{
			// must be implemented by derived classes
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#positionTime
		 */
		public function get positionTime():int
		{
			// must be implemented by derived classes
			return 0;
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#positionPercent
		 */
		public function get positionPercent():Number
		{
			// must be implemented by derived classes
			return 0;
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#duration
		 */
		public function get duration():int
		{
			// must be implemented by derived classes
			return 0;
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#isPlaying
		 */
		public function get isPlaying():Boolean
		{
			// must be implemented by derived classes
			return false;
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#isPaused
		 */
		public function get isPaused():Boolean
		{
			// must be implemented by derived classes
			return false;
		}
		
		
		/**
		 * Creates a new <code>VideoPlayerEvent</code> of a given type.<br>
		 * Used as a shortcut tocreate the event and optionally append the original player event
		 * @param type The event type
		 * @param originalEvent (Optional) The event initially dispatched by the moogaloop player.
		 * @return The created <code>VideoPlayerEvent</code>
		 */ 
		public function createVideoEvent(type:String, originalEvent:Event=null):VideoPlayerEvent
		{
			var event:VideoPlayerEvent = new VideoPlayerEvent( type );
			event.originalEvent = originalEvent;
			return event;
		}
	}
}