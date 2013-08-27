package com.someclip.utils.cache
{
	import flash.system.ApplicationDomain;

	public class CacheManager
	{
		private static var _instance:CacheManager;
		public static const STORE_ONCE:int=0; //只缓存一次
		public static const STORE_UNTIL_REMOVE:int=1; //一直缓存到手动移除
		public static const STORE_ALWAYS:int=2; //一直缓存直到程序结束
		private var _cache:Array;
		private var _type:Array;
		private var _applicationDomains:Array;

		public function CacheManager()
		{
			if (_instance)
				throw new Error("CacheManager是单例，CacheManager.instance获取实例!");
			_cache=new Array();
			_type=new Array();
			_applicationDomains=new Array();
		}

		public static function get instance():CacheManager
		{
			if (!_instance)
				_instance=new CacheManager();
			return _instance;
		}

		/**
		 * 缓存对象
		 * @param key 存储的键名
		 * @param item 存储的对象
		 * @param storeType 存储的时效性,STORE_ONCE=0,标识只存储一次，在取出后消除，STORE_UNTIL_REMOVE=1,标识只存储到被手动移除为止。STORE_ALWAYS=2,标识为只要程序还在运行就一直存在，无法移除.
		 *
		 */
		public function store(key:String, item:Object, storeType:int=STORE_UNTIL_REMOVE, domain:ApplicationDomain=null):void
		{
			_cache[key]=item;
			_type[key]=storeType;
			_applicationDomains[key]=domain;
		}

		/**
		 * 通过键名取缓存对象
		 * 注意：标记为STORE_ONCE的对象在被取出后将直接从缓存中删掉。
		 * @param key 缓存键
		 * @return 缓存的对象
		 *
		 */
		public function pick(key:String):Object
		{
			var obj:Object=_cache[key];
			if (_type[key] == 0)
			{
				_cache[key]=null;
				_type[key]=null;
				delete _cache[key];
				delete _type[key];
				if (_applicationDomains[key] != null)
				{
					_applicationDomains[key]=null;
					delete _applicationDomains[key];
				}
			}
			return obj;
		}

		/**
		 * 获取对应的程序域
		 * @param key 资源键名
		 * @return 程序域的引用
		 *
		 */
		public function pickDomain(key:String):ApplicationDomain
		{
			return _applicationDomains[key];
		}

		/**
		 * 移除cache
		 * 注意：尝试移除标记为 STORE_ALWAYS的对象会报错.
		 * @param key 缓存键
		 *
		 */
		public function remove(key:String):void
		{
			if (!_cache[key])
				return;
			if (_type[key] != STORE_ALWAYS)
			{
				_cache[key]=null;
				_type[key]=null;
				delete _cache[key];
				delete _type[key];
				if (_applicationDomains[key] != null)
				{
					_applicationDomains[key]=null;
					delete _applicationDomains[key];
				}
			}
			else
			{
				throw new Error("无法删除标记为永久缓存的Cache对象");
			}
		}
	}
}
