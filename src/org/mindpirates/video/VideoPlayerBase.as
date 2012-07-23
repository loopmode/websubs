package org.mindpirates.video
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
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
	 * The <code>VideoPlayerBase</code> class is a base class for videoplayer implementations.<br>
	 * The only functions that are concretly implemented are <code>createVideoPlayerEvent</code> and <code>get displayObject</code>.<br>
	 * All other functions must be overriden and implemented by the derived class.<br>
	 * @see #displayObject displayObject
	 * @see #createVideoPlayerEvent() createVideoPlayerEvent
	 * @author Jovica Aleksic
	 */
	public class VideoPlayerBase extends Sprite implements IVideoPlayer
	{
		public function VideoPlayerBase()
		{
			super();
			initJS();
		}
		
		private function initJS():void
		{
			if (ExternalInterface.available) {
				ExternalInterface.addCallback('play', this.play);
				ExternalInterface.addCallback('stop', this.stop);
				ExternalInterface.addCallback('pause', this.pause);
				ExternalInterface.addCallback('seekTo', this.seekToTime); 
				ExternalInterface.addCallback('isReady', this.getIsReady); 
				ExternalInterface.addCallback('isPlaying', this.getIsPlaying); 
				ExternalInterface.addCallback('isPaused', this.getIsPaused);
			}
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
			throw new Error('function get player() not implemented');
			return null;
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#ui 
		 */
		public function get ui():IVideoPlayerUI
		{
			// must be implemented by derived classes
			throw new Error('function get ui() not implemented');
			return null;
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#load() 
		 */
		public function load(id:String):void
		{
			// must be implemented by derived classes
			throw new Error('function load() not implemented');
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#videoID 
		 */
		public function get videoID():String
		{
			// must be implemented by derived classes
			throw new Error('function get videoID() not implemented');
			return null;
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#play() 
		 */
		public function play():void
		{
			// must be implemented by derived classes
			throw new Error('function play() not implemented');
		}
		
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#pause()
		 */
		public function pause():void
		{
			// must be implemented by derived classes
			throw new Error('function pause() not implemented');
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#stop()
		 */
		public function stop():void
		{
			// must be implemented by derived classes
			throw new Error('function stop() not implemented');
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#seekToTime()
		 */
		public function seekToTime(time:int):void
		{
			// must be implemented by derived classes
			throw new Error('function seekToTime() not implemented');
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#seekToPercent()
		 */
		public function seekToPercent(percent:int):void
		{
			// must be implemented by derived classes
			throw new Error('function seekToPercent() not implemented');
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#setSize()
		 */
		public function setSize(w:int, h:int):void
		{
			// must be implemented by derived classes
			throw new Error('function setSize() not implemented');
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#positionTime
		 */
		public function get positionTime():int
		{
			// must be implemented by derived classes
			throw new Error('function get positionTime() not implemented');
			return 0;
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#positionPercent
		 */
		public function get positionPercent():Number
		{
			// must be implemented by derived classes
			throw new Error('function get positionPercent() not implemented');
			return 0;
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#duration
		 */
		public function get duration():int
		{
			// must be implemented by derived classes
			throw new Error('function get duration() not implemented');
			return 0;
		}
		
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#isReady
		 */
		public function get isReady():Boolean
		{
			// must be implemented by derived classes
			throw new Error('function get isReady() not implemented');
			return false;
		}
		
		/**
		 * @private
		 * Makes <code>isReady</code> available ExternalInterface access
		 */
		private function getIsReady():Boolean
		{
			return isReady;
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#isPlaying
		 */
		public function get isPlaying():Boolean
		{
			// must be implemented by derived classes
			throw new Error('function get isPlaying() not implemented');
			return false;
		}
		
		/**
		 * @private
		 * Makes <code>isPlaying</code> available ExternalInterface access
		 */
		private function getIsPlaying():Boolean
		{
			return isPlaying;
		}
		
		/**
		 * @copy org.mindpirates.video.IVideoPlayer#isPaused
		 */
		public function get isPaused():Boolean
		{
			// must be implemented by derived classes
			throw new Error('function get isPaused() not implemented');
			return false;
		}
		
		/**
		 * @private
		 * Makes <code>isPaused</code> available ExternalInterface access
		 */
		private function getIsPaused():Boolean
		{
			return isPaused;
		}
		
		
		/**
		 * Creates a new <code>VideoPlayerEvent</code> of a given type.<br>
		 * Used as a shortcut tocreate the event and optionally append the original player event
		 * @param type The event type
		 * @param originalEvent (Optional) The event initially dispatched by the moogaloop player.
		 * @return The created <code>VideoPlayerEvent</code>
		 */ 
		public function createVideoPlayerEvent(type:String, originalEvent:Event=null):VideoPlayerEvent
		{
			var event:VideoPlayerEvent = new VideoPlayerEvent( type );
			event.originalEvent = originalEvent;
			return event;
		}
		
		public function findPlayerChildren(childClass:Class):Array
		{
			return findNestedChildren(player as DisplayObjectContainer, childClass);
		}
		
		public function findNestedChildren(container:DisplayObjectContainer, childClass:Class):Array 
		{ 
			var result:Array = [];
			var child:DisplayObject; 
			for (var i:uint=0; i < container.numChildren; i++) 
			{ 
				child = container.getChildAt(i);
				if (child is childClass) {
					result.push(child);
				}
				//trace(indentString, child, child.name);  
				if (container.getChildAt(i) is DisplayObjectContainer) 
				{ 
					result = result.concat(findNestedChildren(DisplayObjectContainer(child), childClass));
				} 
			} 
			return result;
		}
	}
}