#!/usr/bin/env ruby

ARGV.each do |input_file_name|
  output_class_name = (input_file_name.split('.')[0..-2]).join('.')
  output_file_name = "#{output_class_name}.as"
  open(input_file_name, 'r') do |input|
    data = input.read
    hex_data = data.each_byte.map{|byte|"#{'0' if byte < 16}#{byte.to_s(16)}"}.each_slice(32).map{|block|block.join('')};
    text = ''
    text << "package {\n"
    text << "\timport flash.utils.ByteArray;\n"
    text << "\tclass #{output_class_name} {\n"
    text << "\t\tpublic function #{output_class_name}() {\n"
    text << "\t\t\tsuper();\n"
    text << "\t\t}\n"
    text << "\t\tprivate static function get _hexData():Array {\n";
    text << "\t\t\treturn [\n"
    text << "\t\t\t\t\"#{hex_data.join("\",\n\t\t\t\t\"")}\"\n"
    text << "\t\t\t];\n"
    text << "\t\t}\n"
    text << "\t\tpublic static function get bytes():ByteArray {\n"
    text << "\t\t\tvar bytes:ByteArray = new ByteArray();\n"
    text << "\t\t\tvar blocks:Array = _hexData;\n"
    text << "\t\t\tvar ic:int = blocks.length;\n"
    text << "\t\t\tfor (var i:int = 0; i < ic; i++) {\n"
    text << "\t\t\t\tvar block:String = blocks[i];\n"
    text << "\t\t\t\tvar length:int = block.length;\n"
    text << "\t\t\t\tvar pos:int = 0;\n"
    text << "\t\t\t\tvar data:int;\n"
    text << "\t\t\t\twhile (pos + 8 <= length) {\n"
    text << "\t\t\t\t\tdata = parseInt(block.substr(pos, 8), 0x10);\n"
    text << "\t\t\t\t\tbytes.writeInt(data);\n"
    text << "\t\t\t\t\tpos += 8;\n"
    text << "\t\t\t\t}\n"
    text << "\t\t\t\twhile (pos < length) {\n"
    text << "\t\t\t\t\tdata = parseInt(block.substr(pos, 2), 0x10);\n"
    text << "\t\t\t\t\tbytes.writeByte(data);\n"
    text << "\t\t\t\t\tpos += 2;\n"
    text << "\t\t\t\t}\n"
    text << "\t\t\t}\n"
    text << "\t\t\treturn bytes;\n"
    text << "\t\t}\n"
    text << "\t}\n"
    text << "}\n"
    open(output_file_name, 'w') do |output|
      output.write(text)
    end
  end
  puts "#{input_file_name} => #{output_file_name}"
end
