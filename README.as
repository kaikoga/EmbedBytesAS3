package {
	import flash.utils.ByteArray;
	class README {
		public function README() {
			super();
		}
		private static function get _hexData():Array {
			return [
				"456d626564204279746573204153330a3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d0a",
				"0a5768617420697320746869733f0a2d2d2d2d2d2d2d2d2d2d2d2d2d0a0a5468",
				"697320527562792070726f6772616d206c65747320796f7520636f6e76657274",
				"206172626974726172792062696e6172792066696c6520696e746f20616e0a41",
				"6374696f6e536372697074332e3020737461746963206d6574686f642e0a0a54",
				"6865207072696d6172792074617267657420697320616c7465726e6174652066",
				"6f7220466c6578205b456d6265645d20746167732e0a0a0a55736167650a2d2d",
				"2d2d2d0a0a2020202024202e2f656d6265645f62797465735f6173332e726220",
				"524541444d452e6d640a0a0a436f707972696768740a2d2d2d2d2d2d2d2d2d0a",
				"0a506c65617365207265666572204c4943454e53452e6d640a"
			];
		}
		public static function get bytes():ByteArray {
			var bytes:ByteArray = new ByteArray();
			var blocks:Array = _hexData;
			var ic:int = blocks.length;
			for (var i:int = 0; i < ic; i++) {
				var block:String = blocks[i];
				var length:int = block.length;
				var pos:int = 0;
				var data:int;
				while (pos + 8 <= length) {
					data = parseInt(block.substr(pos, 8), 0x10);
					bytes.writeInt(data);
					pos += 8;
				}
				while (pos < length) {
					data = parseInt(block.substr(pos, 2), 0x10);
					bytes.writeByte(data);
					pos += 2;
				}
			}
			return bytes;
		}
	}
}
