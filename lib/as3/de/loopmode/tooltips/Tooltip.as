package de.loopmode.tooltips
{
	import com.greensock.TweenLite;
	
	import de.loopmode.tooltips.backgrounds.TooltipBackground;
	
	import embed.fonts.EmbeddedFonts;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Tooltip extends Sprite
	{
		public var padding:Number = 2;
		public var tweenDuration:Number = 0.3;
		public var textFieldOffsetX:Number = 0;
		public var textFieldOffsetY:Number = 0;
		
		
		public static const POSITION_LEFT:String = 'left';
		public static const POSITION_RIGHT:String = 'right';
		public static const POSITION_TOP:String = 'top';
		public static const POSITION_TOP_RIGHT:String = 'topRight';
		public static const POSITION_TOP_LEFT:String = 'topLeft';
		public static const POSITION_BOTTOM:String = 'bottom';
		public static const POSITION_BOTTOM_LEFT:String = 'bottomLeft';
		public static const POSITION_BOTTOM_RIGHT:String = 'bottomRight';
		
		private var _target:DisplayObject;
		private var _text:String;
		private var _background:TooltipBackground;
		private var _textFormat:TextFormat;
		private var _position:*;
			
		private var _textField:TextField;
 		
		private var _xOffset:Number;
		private var _yOffset:Number;
		
		public function Tooltip(target:DisplayObject, tipText:String=null, position:* = null, format:TextFormat=null, bg:TooltipBackground=null, xOffset:Number=0, yOffset:Number=0)
		{
			super();
			alpha = 0;
			mouseEnabled = false;
			mouseChildren = false;
			
			
			_position = position;
			_target = target;
			_text = tipText;
			_textFormat = format;
			_background = bg;
			_xOffset = xOffset;
			_yOffset = yOffset;
			
			if (!_target) {
				throw new IllegalOperationError('target is null or undefined');
				return;
			}
			
			if (!_text) {
				_text = '';
			}
			
			if (!_textFormat) {
				_textFormat = new TextFormat();
				_textFormat.font = 'Arial';
				_textFormat.color = 0x000000;
				_textFormat.size = 9;
			}
			
			if (!_background) {
				_background = new TooltipBackground();
			}
			
			if (!_textField) {
				_textField = new TextField();
			}

			_target.addEventListener(Event.ADDED_TO_STAGE, startListening);
			_target.addEventListener(Event.REMOVED_FROM_STAGE, stopListening);
			
			
			if (_target.parent) startListening();
			
		}
		
		public function set text(value:String):void
		{
			_text = value;
			update();
		}
		
		public function get text():String
		{
			return _text;
		}
		
		
		public function set textFormat(value:TextFormat):void
		{
			_textFormat = value;
			update();
		}
		
		public function get textFormat():TextFormat
		{
			return _textFormat;
		}
		 
		
		public function set background(value:TooltipBackground):void
		{
			_background = value;
			update();
		}
		
		public function get background():TooltipBackground
		{
			return _background;
		}
		
		
		
		public function set textField(value:TextField):void
		{
			_textField = value;
			update();
		}
		
		public function get textField():TextField
		{
			return _textField;
		}
		 
		
		public function set position(value:*):void
		{
			_position = value;
			update();
		}
		public function get position():*
		{
			return _position;
		}
		
		
		
		private function update(e:MouseEvent = null):void
		{
			if (_background) {
				if (!contains(_background)) {
					addChildAt(_background, 0);
				}
			} 
			else {
				throw new IllegalOperationError('_background is null or undefined');
			}
			
			
			if (_textField) {
				if (!contains(_textField)) {
					addChildAt(_textField, 1);
				}
			}
			else {
				throw new IllegalOperationError('_textfield is null or undefined');
			}
			
			
			
			_textField.x = int(padding + textFieldOffsetX);
			_textField.y = int(padding + textFieldOffsetY);
			
			var embedFonts:Boolean = false;
			var embeddedFonts:Array = Font.enumerateFonts();
			for each (var f:Font in embeddedFonts) {
				if (f.fontName === _textFormat.font) {
					embedFonts = true;
				}
			}
			
			//_textfield.embedFonts = true;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.embedFonts = embedFonts;
			_textField.defaultTextFormat = _textFormat;
			_textField.text = _text;
			
			_background.setTooltip(this);
			_background.draw(_textField.width + 2*padding, _textField.height + 2*padding);
			
			updatePosition(e);
			
		}		
		
		private function updatePosition(e:MouseEvent = null):void
		{
			var _x:Number, _y:Number;
			
			switch (_position) {
				
				case POSITION_RIGHT:
					_x = _target.x + _target.width;
					_y = _target.y + 0.5 * (_target.height - _background.height);
					break;
				
				case POSITION_LEFT:
					_x = _target.x - _background.width;
					_y = _target.y + 0.5 * (_target.height - _background.height);
					break; 
				
				case POSITION_TOP:
					_x = _target.x + 0.5 * (_target.width - _background.width);
					_y = _target.y - _background.height;
					break;
				
				case POSITION_TOP_LEFT:
					_x = _target.x - _background.width;
					_y = _target.y - _background.height;
					break;
				
				case POSITION_TOP_RIGHT:
					_x = _target.x + _target.width;
					_y = _target.y - _background.height;
					break;
				
				case POSITION_BOTTOM:
					_x = _target.x + 0.5 * (_target.width - _background.width);
					_y = _target.y + _target.height;
					break;
				
				case POSITION_BOTTOM_LEFT:
					_x = _target.x - _background.width;
					_y = _target.y + _target.height;
					break;
				
				case POSITION_BOTTOM_RIGHT:
					_x = _target.x + _target.width;
					_y = _target.y + _target.height;
					break;
				
				default: 
					if (_position) {
						if ( _position.x) _x = _position.x;
						if ( _position.y) _y = _position.y;
					}
					else {
						if (e) {
							_x = e.stageX;
							_y = e.stageY;
						}
					}
					break;
			}	
			
			x = int(_x + _xOffset);
			y = int(_y + _yOffset);		
		}
		
		
		private function startListening(event:Event=null):void
		{
			_target.addEventListener(MouseEvent.ROLL_OVER, handleTargetRollOver);
			_target.addEventListener(MouseEvent.ROLL_OUT, handleTargetRollOut);
		}
		
		
		private function stopListening(event:Event=null):void
		{
			_target.removeEventListener(MouseEvent.ROLL_OVER, handleTargetRollOver);
			_target.removeEventListener(MouseEvent.ROLL_OUT, handleTargetRollOut);			
		}
		
		
		
		private function handleTargetRollOver(event:MouseEvent):void
		{
			show(event);
		}
		
		private function handleTargetRollOut(event:MouseEvent):void
		{
			hide();
		}
		
		
		
		
		public function show(e:MouseEvent=null):void
		{
			if (!_target.stage) {
				trace(this, 'show() failed because target is not in DisplayList');
				return;
			}
			
			_target.stage.addChild(this);
			alpha = 0;
			
			update(e);
			
			if (_position === null) {
				_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, updatePosition);
			}
			
			TweenLite.to(this, tweenDuration, {
				alpha: 1
			});
			
			dispatchEvent( new Event( 'show' ) );
		}
		 
		public function hide():void
		{
			TweenLite.to(this, tweenDuration, {
				alpha: 0,
				onComplete: hideComplete 
			});
			dispatchEvent( new Event( 'hide' ) );
		}
		
		private function hideComplete(e:Event=null):void
		{
			if (!stage) {
				return;
			}
			if (_position === null) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, updatePosition);
			}
			stage.removeChild(this);
		}
		
		
		
		
		
		public function destroy():void
		{
			if (_background && contains(_background)) {
				removeChild(_background);
			}
			_background = null;
			
			if (_textField && contains(_textField)) {
				removeChild(_textField);
			}
			_textField = null;

			stopListening();
			
			_target.addEventListener(Event.ADDED_TO_STAGE, startListening);
			_target.addEventListener(Event.REMOVED_FROM_STAGE, stopListening);
			
		}
	}
}