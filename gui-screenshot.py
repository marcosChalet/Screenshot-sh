import tkinter as tk
import subprocess
import math

click_x, click_y, rel_x, rel_y = 0, 0, 0, 0
root = tk.Tk()
root.geometry('400x200')
root.config(bg='#7c7e89')
root.resizable(False, False)
root.title('Chalet Screenshot')

radio_var = tk.IntVar()
checkb_var = tk.IntVar()


def calc_dim():
    print('Calculating dimensions')
    global click_x, click_y, rel_x, rel_y
    x = math.fabs(click_x - rel_x)
    y = math.fabs(click_y - rel_y)
    x = int(x)
    y = int(y)

    if checkb_var.get():
        return f'-c -x {x}x{y}+{click_x}+{click_y}'
    else:
        return f'-x {x}x{y}+{click_x}+{click_y}'


def click_mouse(event):
    print(f'Point click: {event.x, event.y}')
    global click_x, click_y
    click_x = event.x
    click_y = event.y


def rel_mouse(event, new):
    print(f'Point release: {event.x, event.y}')
    global rel_x, rel_y
    rel_x = event.x
    rel_y = event.y
    new.destroy()

    opt_cut_screen = calc_dim()

    print(f"Coammand: {opt_cut_screen}")
    subprocess.call(f'./chalet-screenshot.sh {opt_cut_screen}', shell=True)


def capture():
    if radio_var.get() == 1:
        print('Capturing the entire screen!')
        root.destroy()

        if checkb_var.get():
            subprocess.call('./chalet-screenshot.sh -c', shell=True)
        else:
            subprocess.call('./chalet-screenshot.sh', shell=True)

    else:
        root.destroy()

        # Open a new window to select area
        new = tk.Tk()
        new.wait_visibility(new)
        new.attributes('-alpha', 0.2)

        # Capture the dimension of screenshot
        new.attributes('-fullscreen', True)
        new.bind('<Button-1>', click_mouse)
        new.bind('<ButtonRelease>', lambda event: rel_mouse(event, new))


# Creating buttons to chosen option
radio_opt_full = tk.Radiobutton(root, text='Full screen',
                                highlightthickness=0,
                                bg='#7c7e89',
                                variable=radio_var, value=1)

radio_opt_select = tk.Radiobutton(root, text='Select area',
                                  highlightthickness=0,
                                  bg='#7c7e89',
                                  variable=radio_var, value=2)
# Positioning buttons
radio_opt_full.grid(column=0, row=0)
radio_opt_select.grid(column=0, row=1)

# Checkbutton to coppy to clipboard
check_cp = tk.Checkbutton(root, text='Clipboard',
                          variable=checkb_var,
                          highlightthickness=0,
                          bg='#7c7e89',
                          onvalue=1, offvalue=0,
                          height=2, width=9)
check_cp.grid(column=0, row=2)

# Creating button to take a screenshot of chosen option
button_take = tk.Button(root, text='screenshot', command=capture)
# button_take.place(x=150, y=160, anchor=tk.CENTER)
button_take.place(relx=0.4, rely=0.8, anchor=tk.NW)

root.mainloop()
