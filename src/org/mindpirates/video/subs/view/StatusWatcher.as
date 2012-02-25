package org.mindpirates.video.subs.view
{
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.text.TextField;
	
	import org.mindpirates.video.events.SubtitleFileLoaderEvent;
	import org.mindpirates.video.subs.Strings;
	import org.mindpirates.video.subs.Subtitles;
	import org.mindpirates.video.subs.loading.SubtitleFileLoader;
	
	import utils.StringUtils;

	public class StatusWatcher
	{
		private var _target:Subtitles;
		private var _file:SubtitleFileLoader;
		public function StatusWatcher(target:Subtitles, fileLoader:SubtitleFileLoader)
		{
			_target = target;
			_file = fileLoader;
			
			_file.addEventListener(SubtitleFileLoaderEvent.LOAD, showLoadingSubtitlesMessage);
			_file.addEventListener(SubtitleFileLoaderEvent.PROGRESS, showLoadingSubtitlesMessage);
			_file.addEventListener(SubtitleFileLoaderEvent.FONT_LOAD, showLoadingFontMessage);
			_file.addEventListener(SubtitleFileLoaderEvent.FONT_PROGRESS, showLoadingFontMessage);
			_file.addEventListener(SubtitleFileLoaderEvent.FONT_COMPLETE, showCompleteMessage);
			_file.addEventListener(SubtitleFileLoaderEvent.COMPLETE, showCompleteMessage);
			
		}
		
		public function destroy():void
		{
			_file.removeEventListener(SubtitleFileLoaderEvent.LOAD, showLoadingSubtitlesMessage);
			_file.removeEventListener(SubtitleFileLoaderEvent.PROGRESS, showLoadingSubtitlesMessage);
			_file.removeEventListener(SubtitleFileLoaderEvent.FONT_LOAD, showLoadingFontMessage);
			_file.removeEventListener(SubtitleFileLoaderEvent.FONT_PROGRESS, showLoadingFontMessage);
			_file.removeEventListener(SubtitleFileLoaderEvent.FONT_COMPLETE, showCompleteMessage);
			_file.removeEventListener(SubtitleFileLoaderEvent.COMPLETE, showCompleteMessage); 
			_file = null;
		}
		 
		
		
		protected function showLoadingSubtitlesMessage(event:SubtitleFileLoaderEvent):void
		{
			var message:String = Strings.STATUS_LOADING_SUBTITLES;
			var fileName:String = StringUtils.getFileName(_file.fileURL);
			var percent:Number = event.bytesTotal ?  Math.round(event.bytesLoaded/event.bytesTotal*1000)/10 : 0;
			message = message.replace('{name}', fileName);
			message = message.replace('{percent}', percent); 
			_target.view.statusMessage = message; 
		}
		protected function showLoadingFontMessage(event:SubtitleFileLoaderEvent):void
		{
			var message:String = Strings.STATUS_LOADING_FONT;
			var fileName:String = StringUtils.getFileName(_file.fontFile);
			var percent:Number = event.bytesTotal ?  Math.round(event.bytesLoaded/event.bytesTotal*1000)/10 : 0;
			message = message.replace('{name}', _file.fontName+' ('+fileName+')');
			message = message.replace('{percent}', percent); 
			_target.view.statusMessage = message;  
		}
		
		protected function showCompleteMessage(event:SubtitleFileLoaderEvent):void
		{
			_target.view.statusMessage = null;
		}
		 
	}
}