package org.mindpirates.video
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	/**
	 * The IVideoPlayer interface defines common functions to be implemented by videoplayer clases. 
	 * @author Jovica Aleksic (jovi@mindpirates.org)
	 */
	public interface IVideoPlayer extends IEventDispatcher
	{
		
		/**
		 * Whether or not the external player is loaded and ready.
		 */
		function get isReady():Boolean;
		
		/**
		 * Reference to the loaded external player
		 */ 
		function get player():Object;
		
		/**
		 * Reference to a class that implements the <code>IVideoPlayerUI</code> interface and gives access to the player's UI elements.
		 * @see org.mindpirates.video.IVideoPlayerUI
		 */
		function get ui():IVideoPlayerUI;
		
		/**
		 * A reference to itself casted as DisplayObject.
		 */
		function get displayObject():DisplayObject;
		
		/**
		 * Destroys and cleans up the instance.
		 */
		function destroy():void;
		
		/**
		 * Loads a new video.
		 * @param id The id of the new video.
		 */
		function load(id:String):void;
		
		/**
		 * The id of the current video.
		 */
		function get videoID():String;
		/**
		 * Starts playback from the current position.
		 */
		function play():void;
		
		/**
		 * Pauses the playback without changing the position.
		 */
		function pause():void;
		
		/**
		 * Stops the playback and resets the position to the beginning of the video.
		 */
		function stop():void;
		
		/**
		 * Seeks to a position based on miliseconds.
		 * @param time The target position in miliseconds
		 */
		function seekToTime(time:int):void;
		
		/**
		 * Seeks to a position based on percentage.
		 * @param percent The target position in percent
		 */
		function seekToPercent(percent:int):void;
		
		/**
		 * Sets the size of the video player.
		 * @param w The width in pixels.
		 * @param h The height in pixels.
		 */
		function setSize(w:int, h:int):void;
		
		/**
		 * The current playback position in miliseconds.
		 */
		function get positionTime():int;
		
		/**
		 * The current playback position in percent.
		 */
		function get positionPercent():Number;
		
		/**
		 * The duration of the current video in miliseconds
		 */
		function get duration():int;
		
		/**
		 * Whether playback is currently active or not.
		 */
		function get isPlaying():Boolean;
		
		/**
		 * Whether playback is currently paused.
		 */
		function get isPaused():Boolean;
	}
}