# -*- coding: utf-8

''' 对json数据文件进行处理，输出特定字段内容 '''

import sys
import json


def output_fields(d, field_list):
    output_list = []
    for field in field_list:
        if field in d:
            if isinstance(d[field], unicode):
                output_list.append(d[field].encode('utf-8'))
            else:
                output_list.append(str(d[field]))

    print "\t".join(output_list)


def process(field_list):

    index = 0
    for line in sys.stdin:
        index += 1
        line = line.strip()
        try:
            d = json.loads(line)
        except:
            sys.stderr.write('load json failed in line[%d]' % index)
            continue

        output_fields(d, field_list)

if __name__ == '__main__':

    if len(sys.argv) <= 1:
        sys.stderr.write('usags: %s field-1 field-2 ...' % sys.argv[0])
        exit(0)

    process(sys.argv[1:])
