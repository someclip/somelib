package com.someclip.utils.media
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;

	public class SoundManager extends EventDispatcher
	{
		private static var _instance:SoundManager;
		private var _isMusicMute:Boolean;
		private var _isSoundMute:Boolean;
		private var _systemVolume:Number;
		private var _musicVolume:Number;
		private var _from:Number;
		private var _to:Number;
		private var _musicChannel:SoundChannel;
		private var _sounds:Array;
		private var _soundLoader:Sound;
		private var _loops:int;
		private var _source:String;

		public function SoundManager()
		{
			if (_instance)
				throw new Error("SoundManager Singleton Error!,SoundManager.instance获取实例");
			_sounds=new Array();
		}

		public function registerSound(label:String, soundIns:Sound):void
		{
			_sounds[label]=soundIns;
		}

		public function removeSound(label:String):void
		{
			if (_sounds[label])
			{
				_sounds[label]=null;
				delete _sounds[label];
			}
		}

		public function playSoundByLabel(label:String):void
		{
			var sound:Sound=_sounds[label];
			if (sound)
			{
				playSound(sound);
				sound=null;
			}
		}

		public function stopMusic():void
		{
			if (_musicChannel != null)
			{
				_musicChannel.stop();
			}
		}

		public function playSound(soundIns:Sound):void
		{
			if (_isSoundMute)
				return;
			soundIns.play(0, 0);
		}

		public function playMusicByLabel(label:String, startPos:Number=0, loops:int=0):void
		{
			var music:Sound=_sounds[label];
			if (music)
			{
				if (_musicChannel != null)
				{
					_musicChannel.stop();
					_musicChannel=null;
				}
				_musicChannel=music.play(startPos, loops);
				music=null;
			}
		}

		public function playMusic(musicIns:Sound, startPos:Number=0, loops:int=0):void
		{
			if (_musicChannel != null)
			{
				_musicChannel.stop();
				_musicChannel=null;
			}
			_musicChannel=musicIns.play(startPos, loops);
			musicIns=null;
		}

		public function loadAndPlayMusic(source:String, startPos:Number, loops:int=0):void
		{
			_source=source;
			_loops=loops;
			if (_isMusicMute)
				return;

			if (_soundLoader)
			{
				try
				{
					_soundLoader.close();
				}
				catch (e:Error)
				{
				}
				_soundLoader=null;
			}
			if (_musicChannel)
			{
				_musicChannel.stop();
				_musicChannel=null;
			}
			_soundLoader=new Sound();
			_soundLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_soundLoader.addEventListener(Event.OPEN, openHandler);
			_soundLoader.load(new URLRequest(source));
		}

		private function openHandler(event:Event):void
		{
			_musicChannel=_soundLoader.play(0, _loops);
		}

		private function ioErrorHandler(event:IOErrorEvent):void
		{

		}

		public function get isSoundMute():Boolean
		{
			return _isSoundMute;
		}

		public function set isSoundMute(value:Boolean):void
		{
			_isSoundMute=value;
		}

		public function get isMusicMute():Boolean
		{
			return _isMusicMute;
		}

		public function set isMusicMute(value:Boolean):void
		{
			_isMusicMute=value;
			if (_musicChannel == null)
				return;
			var st:SoundTransform=_musicChannel.soundTransform;
			if (_isMusicMute)
			{
				_musicVolume=st.volume;
				st.volume=0;
				_musicChannel.soundTransform=st;
				st=null;
			}
			else
			{
				st.volume=_musicVolume;
				_musicChannel.soundTransform=st;
				st=null;
				if (_source)
				{
					loadAndPlayMusic(_source, 0, _loops);
				}
			}

		}


		private function easingVolume(from:Number, to:Number):void
		{
			_from=from;
			_to=to;
			setTimeout(easing, 500);
		}

		private function easing():void
		{
			if (_from == _to)
			{
				return;
			}
			var dis:Number=_to - _from;
			var abs:Number=dis < 0 ? -dis : dis;
			if (dis < 0.1)
			{
				_from=_to;
			}
			else
			{
				_from+=(dis / abs) * 0.1;
			}
			var st:SoundTransform=SoundMixer.soundTransform;
			st.volume=_from;
			SoundMixer.soundTransform=st;
			st=null;
			setTimeout(easing, 500);
		}

		public static function get instance():SoundManager
		{
			if (!_instance)
				_instance=new SoundManager();
			return _instance;
		}
	}
}
