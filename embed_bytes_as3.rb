#!/usr/bin/env ruby

require "fileutils"

input_file_names = []
output_fqn_names = []

if ARGV.count == 0
  puts 'Usage: embed_bytes_as3.rb [-o OUTPUT] [INPUT]'
  puts 'Usage: embed_bytes_as3.rb INPUT1 [-o OUTPUT1] [INPUT2 [-o OUTPUT2] ...]'
  puts 'INPUT: file name'
  puts 'OUTPUT: AS3 fully qualified class name'
  exit
end

args = ARGV.dup
while args.count > 0
  input_file_names.push(args.shift)
  case args[0]
  when "-o"
    args.shift
    output_fqn_names[[input_file_names.length - 1, 0].max] = args.shift
  end
end

input_file_names.zip(output_fqn_names) do |input_file_name, output_fqn_name|
  output_fqn_name ||= (input_file_name.split('.')[0..-2]).join('.')
  output_file_name = "#{File.join(output_fqn_name.split('.'))}.as"
  *output_package, output_class_name = output_fqn_name.split('.')
  puts "#{input_file_name} => #{output_file_name}"
  open(input_file_name, 'r') do |input|
    data = input.read
    hex_data = data.each_byte.map{|byte|"#{'0' if byte < 16}#{byte.to_s(16)}"}.each_slice(32).map{|block|block.join('')};
    text = ''
    text << "package #{"#{output_package.join('.')} " if output_package.count > 0}{\n"
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
    FileUtils.mkdir_p(File.join(output_package)) if output_package.count > 0
    open(output_file_name, 'w') do |output|
      output.write(text)
    end
  end
end
