/*
 * This file is part of screenshot-applet
 *
 * Copyright (C) 2016 Stefan Ric <stfric369@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

namespace ScreenshotApplet
{
    public class CountdownView : Gtk.Box
    {
        public GLib.Cancellable cancellable;
        private Gtk.Stack stack;
        public Gtk.Label label1;
        private Gtk.Label label2;

        private static GLib.Once<CountdownView> _instance;

        public signal void cancelled();

        public CountdownView()
        {
            Object(spacing: 0, orientation: Gtk.Orientation.VERTICAL);
            margin = 20;
            width_request = 200;
            height_request = 150;

            label1 = new Gtk.Label("");
            label1.use_markup = true;

            label2 = new Gtk.Label("");
            label2.use_markup = true;

            stack = new Gtk.Stack();
            stack.transition_type = Gtk.StackTransitionType.SLIDE_DOWN;
            stack.transition_duration = 200;
            stack.set_interpolate_size(true);
            stack.add_named(label1, "label1");
            stack.add_named(label2, "label2");

            Gtk.Button cancel_button = new Gtk.Button.with_label("Cancel");
            cancel_button.margin_top = 20;
            cancel_button.can_focus = false;

            cancel_button.clicked.connect(() => { cancelled(); cancellable.cancel(); });

            pack_start(stack, true, true, 0);
            pack_start(cancel_button, true, true, 0);
        }

        public void change_label(string left)
        {
            if (stack.visible_child_name == "label1") {
                stack.visible_child_name = "label2";
            } else {
                stack.visible_child_name = "label1";
            }

            label1.label = @"<span font='50'>$left</span>";
            label2.label = @"<span font='50'>$left</span>";

            if (left == "0") {
                set_label("Cheese!");
            }
        }

        public void set_label(string label) {
            label1.label = @"<span font='42'>$label</span>";
            stack.visible_child_name = "label1";
        }

        public static unowned CountdownView instance() {
            return _instance.once(() => { return new CountdownView(); });
        }
    }
}