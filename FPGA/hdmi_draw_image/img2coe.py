#! /usr/bin/env python3
'''
File Name: image2coe.py
Author: Jesse Millwood & Hongming Zhu
Python Version: 3.11
Date: July 4 2024


Description:
    This script loads in an image defined by the user and converts it to a
    Xilinx Coefficients File (.coe)
    The majority of this code is just adapted from a MATLAB script, "IMG2coe8.m",
    that was found in an on-line example at: 
    http://www.lbebooks.com/downloads.htm#vhdlnexys
    The specific example is at:
    http://www.lbebooks.com/downloads/exportal/VHDL_NEXYS_Example24.pdf

TO USE:
    The easiest way to use this script is to copy this module to the directory
    that contains the image that you want to convert. Then  start and instance 
    or your terminal emulator or command prompt in that same directory. Run this 
    module with the python command from the terminal emulator or command prompt
    text editor and change the contents of the string named ImageName. 
    Then run the script from a command line.
'''
# Imported Standard Modules
import sys
from PIL import Image 



def convert (imagename):
    """
        This converts the given image into a Xilinx Coefficients (.coe) file.
        Pass it the name of the image including the file suffix.
        The file must reside in the directory from which this function is called
        or provide the absolute path. 
    """
    # Open image
    img     = Image.open(imagename)
    # Verify that the image is in the 'RGB' mode, every pixel is described by 
    # three bytes
    if img.mode != 'RGB':
        img = img.convert('RGB')

    # Store Width and height of image
    width     = img.size[0]
    height    = img.size[1]

    # Create a .coe file and open it.
    # Write the header to the file, where lines that start with ';' 
    # are commented
    filetype = imagename[imagename.find('.'):]
    filename = imagename.replace(filetype,'.coe')
    imgcoe    = open(filename,'w')
    imgcoe.write(';    VGA Memory Map\n')
    imgcoe.write('; .COE file with hex coefficients\n')
    imgcoe.write(f'; Height: {height}, Width: {width}\n')
    imgcoe.write('memory_initialization_radix = 16;\n')
    imgcoe.write('memory_initialization_vector =\n')
    
    # Iterate through every pixel, retain the 3 least significant bits for the
    # red and green bytes and the 2 least significant bits for the blue byte. 
    # These are then combined into one byte and their hex equivalent is written
    # to the .coe file
    cnt = 0
    line_cnt = 0
    for y in range(0, height):
        for x in range(0, width):
            cnt += 1
            # Check for IndexError, usually occurs if the script is trying to 
            # access an element that does not exist
            try:
                R,G,B = img.getpixel((x,y))
            except IndexError:
                print('Index Error Occurred At:')
                print('c: {x}, r:{y}')
                sys.exit()
            # Check for Value Error, happened when the case of the pixel being 
            # zero was not handled properly    
            try:
                imgcoe.write(f'{R:02X}{G:02X}{B:02X}')
            except ValueError:
                print('Value Error Occurred At:')
                print('Contents of Outbyte: {0} at r:{1} c:{2}'.format(Outbyte,y,x))
                print(f'R:{R} G:{G} B{B}')
                print(f'Rb:{Rb} Gb:{Gb} Bb:{Bb}')
                sys.exit()
            # Write correct punctuation depending on line end, byte end,
            # or file end
            if x==width-1 and y==height-1:
                imgcoe.write(';')
            else:
                if cnt%32 == 0:
                    imgcoe.write(',\n')
                    line_cnt+=1
                else:
                    imgcoe.write(',')
    imgcoe.close()
    print(f'Xilinx Coefficients File:{filename} DONE')
    print(f'Converted from {filetype} to .coe')
    print(f'Size: h:{height} pixels w:{width} pixels')
    print(f'Total addresses: {32*(line_cnt+1)}')



if __name__ == '__main__':
    # if argument is passed, use it as the image name
    if len(sys.argv) > 1:
        imagename = sys.argv[1]
    else:
        imagename = input('Enter the name of your image: ')
    convert(imagename)
