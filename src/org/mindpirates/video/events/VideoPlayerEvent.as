package org.mindpirates.video.events
{
	import flash.events.Event;
	
	
	/**
	 * This event is Dispatched when the playback state of the VideoPlayer changes.
	 */
	
	public class VideoPlayerEvent extends Event
	{
		
		
		/**
		 * Dispatched when an error occurs in the player.
		 */
		public static const ERROR:String = "error";
		
		/**
		 * Dispatched when the player has finished loading.
		 */
		public static const PLAYER_READY:String = "playerReady";
		
		/**
		 * Dispatched when the current video is ready for playback.
		 */
		public static const VIDEO_READY:String = "videoReady";
		
		/**
		 * Dispatched whenever playback is started.
		 */
		public static const PLAY:String = "play";
		
		/**
		 * Dispatched whenever playback is paused.
		 */
		public static const PAUSE:String = "pause";
		
		/**
		 * Dispatched whenever playback is stopped.
		 */
		public static const STOP:String = "stop";
		
		/**
		 * Dispatched whenever playback is seeked to a new position.
		 */
		public static const SEEK:String = "seek";
		
		/**
		 * Dispatched while playback is active.
		 */
		public static const PLAY_PROGRESS:String = "playProgress";
		
		/**
		 * Dispatched when a new video file starts loading.
		 */
		public static const LOAD:String = "load";
		
		/**
		 * Dispatched while the video file is being loaded.
		 */
		public static const LOAD_PROGRESS:String = "loadProgress";
		 
		/**
		 * The original event dispatched by the player. (Optional)<br>
		 * NOTE: This property is only included when an event was initially dispatched by the used player, so make sure to check for its existence before referencing.
		 */
		public var originalEvent:Event;
		
		public function VideoPlayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}