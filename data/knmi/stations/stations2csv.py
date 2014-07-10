#!/usr/bin/env python

__author__ = 'just'

def main():


    f = open('stations.ncdump.txt', 'r')

    line = ''
    # data section reached?
    while line != 'data:':
        line = f.readline()
        line = line.strip()
        # print line

    # line == data:

    # data section reached?
    content = list()
    while line != '}':
        line = f.readline()
        line = line.strip()

        if '=' in line:
            col, _, valueStr = line.rpartition('=')
            while ';' not in line:
                line = f.readline()
                line = line.strip()
                valueStr += line.strip(';')
            valueArr = valueStr.split(',')

            content.append((col.strip(), valueArr))
        # print line

    # Get header line
    header = ''
    rngCols = len(content)
    for i in range(rngCols):
        (col, val) = content[i]
        header += col
        if i != rngCols - 1:
            header += ','

    print header

    # Get content line
    # vals = [[None] * rngCols] * 60
    vals = [['' for i in range(rngCols)] for j in range(60)]
    rngCol = len(content)
    for i in range(rngCol):
        (col, valArr) = content[i]

        valRng = len(valArr)
        for j in range(valRng):
            val = valArr[j]
            valj = vals[j]
            valj[i] = val

    # print (vals)
    vl = 60
    for i in range(vl):
        valStr = ",".join(vals[i]).strip()
        print valStr

if __name__ == "__main__":
    main()
