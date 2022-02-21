'''
Created on 7 feb. 2022

@author: Javier
'''
"""
# Importing tkinter module
from tkinter import * 
from tkinter.ttk import *

# creating Tk window
master = Tk()

# creating a Fra, e which can expand according
# to the size of the window
pane = Frame(master)
pane.pack(fill = BOTH, expand = True)

# button widgets which can also expand and fill
# in the parent widget entirely
# Button 1
b1 = Button(pane, text = "Click me !")
b1.pack(fill = BOTH, expand = True)

# Button 2
b2 = Button(pane, text = "Click me too")
b2.pack(fill = BOTH, expand = True)

# Execute Tkinter
master.mainloop()


"""
from tkinter import *
root = Tk()
root.title("YATA Update and reconfig")
# Hijo de root, no ocurre nada
frame = Frame(root)  

# Empaqueta el frame en la ra�z
frame.pack()      

# Como no tenemos ning�n elemento dentro del frame, 
# no tiene tama�o y aparece ocupando lo m�nimo posible, 0*0 px

# Color de fondo, background
frame.config(bg="blue")     

# Podemos establecer un tama�o,
# la ra�z se adapta al frame que contiene
frame.config(width=640,height=480) 

root.mainloop()       



