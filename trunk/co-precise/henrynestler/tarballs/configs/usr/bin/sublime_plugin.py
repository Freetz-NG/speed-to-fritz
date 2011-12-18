import os
import sys

application_command_classes = []
window_command_classes = []
text_command_classes = []

all_command_classes = [application_command_classes, window_command_classes, text_command_classes]

all_callbacks = {'on_new': [], 'on_clone': [], 'on_load': [], 'on_close': [],
    'on_pre_save': [], 'on_post_save': [], 'on_modified': [],
    'on_selection_modified': [],'on_activated': [], 'on_deactivated': [],
    'on_project_load': [], 'on_project_close': [], 'on_query_context': [],
    'on_query_completions': []}

def unload_module(module):
    if "unload_handler" in module.__dict__:
        module.unload_handler()

    # Unload the old plugins
    if "plugins" in module.__dict__:
        for p in module.plugins:
            for cmd_cls_list in all_command_classes:
                try:
                    cmd_cls_list.remove(p)
                except ValueError:
                    pass
            for c in all_callbacks.values():
                try:
                    c.remove(p)
                except ValueError:
                    pass

def unload_plugin(fname):
    print "Unloading plugin", fname

    modulename, ext = os.path.splitext(os.path.basename(fname))

    was_loaded = modulename in sys.modules
    if was_loaded:
        m = __import__(modulename)
        unload_module(m)

def reload_plugin(fname):
    print "Reloading plugin", fname
    path = os.path.dirname(fname)

    # Change the current directory to that of the module. It's not safe to just
    # add the modules directory to sys.path, as that won't accept unicode paths
    # on Windows
    oldpath = os.getcwdu()
    os.chdir(path)

    modulename, ext = os.path.splitext(os.path.basename(fname))

    was_loaded = modulename in sys.modules
    m = __import__(modulename)
    if was_loaded:
        unload_module(m)
        # Reload the module
        reload(m)

    # Restore the current directory
    os.chdir(oldpath)

    module_plugins = []
    for type_name in dir(m):
        try:
            t = m.__dict__[type_name]
            if t.__bases__:
                is_plugin = False
                if issubclass(t, ApplicationCommand):
                    application_command_classes.append(t)
                    is_plugin = True
                if issubclass(t, WindowCommand):
                    window_command_classes.append(t)
                    is_plugin = True
                if issubclass(t, TextCommand):
                    text_command_classes.append(t)
                    is_plugin = True

                if is_plugin:
                    module_plugins.append(t)

                if issubclass(t, EventListener):
                    obj = t()
                    for p in all_callbacks.iteritems():
                        if p[0] in dir(obj):
                            p[1].append(obj)

                    module_plugins.append(obj)

        except AttributeError:
            pass

    if len(module_plugins) > 0:
        m.plugins = module_plugins

def create_application_commands():
    cmds = []
    for class_ in application_command_classes:
        cmds.append(class_())
    return cmds

def create_window_commands(window):
    cmds = []
    for class_ in window_command_classes:
        cmds.append(class_(window))
    return cmds

def create_text_commands(view):
    cmds = []
    for class_ in text_command_classes:
        cmds.append(class_(view))
    return cmds

def on_new(v):
    for callback in all_callbacks['on_new']:
        callback.on_new(v)

def on_clone(v):
    for callback in all_callbacks['on_clone']:
        callback.on_clone(v)

def on_load(v):
    for callback in all_callbacks['on_load']:
        callback.on_load(v)

def on_close(v):
    for callback in all_callbacks['on_close']:
        callback.on_close(v)

def on_pre_save(v):
    for callback in all_callbacks['on_pre_save']:
        callback.on_pre_save(v)

def on_post_save(v):
    for callback in all_callbacks['on_post_save']:
        callback.on_post_save(v)

def on_modified(v):
    for callback in all_callbacks['on_modified']:
        callback.on_modified(v)

def on_selection_modified(v):
    for callback in all_callbacks['on_selection_modified']:
        callback.on_selection_modified(v)

def on_activated(v):
    for callback in all_callbacks['on_activated']:
        callback.on_activated(v)

def on_deactivated(v):
    for callback in all_callbacks['on_deactivated']:
        callback.on_deactivated(v)

def on_project_load(w):
    for callback in all_callbacks['on_project_load']:
        callback.on_project_load(w)

def on_project_close(w):
    for callback in all_callbacks['on_project_close']:
        callback.on_project_close(w)

def on_query_context(v, key, operator, operand, match_all):
    for callback in all_callbacks['on_query_context']:
        v = callback.on_query_context(v, key, operator, operand, match_all)
        if v:
            return True
    return False

def on_query_completions(v, prefix, locations):
    completions = []
    for callback in all_callbacks['on_query_completions']:
        completions += callback.on_query_completions(v, prefix, locations)
    return completions

class Command(object):
    def name(self):
        clsname = self.__class__.__name__
        name = clsname[0].lower()
        last_upper = False
        for c in clsname[1:]:
            if c.isupper() and not last_upper:
                name += '_'
                name += c.lower()
            else:
                name += c
            last_upper = c.isupper()
        if name.endswith("_command"):
            name = name[0:-8]
        return name

    def is_enabled_(self, args):
        try:
            if args:
                if 'event' in args:
                    del args['event']

                return self.is_enabled(**args)
            else:
                return self.is_enabled()
        except TypeError:
            return self.is_enabled()

    def is_enabled(self):
        return True

    def is_visible_(self, args):
        try:
            if args:
                return self.is_visible(**args)
            else:
                return self.is_visible()
        except TypeError:
            return self.is_visible()

    def is_visible(self):
        return True

    def description_(self, args):
        try:
            if args:
                return self.description(**args)
            else:
                return self.description()
        except TypeError as e:
            return None

    def description(self):
        return None


class ApplicationCommand(Command):
    def run_(self, args):
        if args:
            if 'event' in args:
                del args['event']

            return self.run(**args)
        else:
            return self.run()

    def run(self):
        pass


class WindowCommand(Command):
    def __init__(self, window):
        self.window = window

    def run_(self, args):
        if args:
            if 'event' in args:
                del args['event']

            return self.run(**args)
        else:
            return self.run()

    def run(self):
        pass


class TextCommand(Command):
    def __init__(self, view):
        self.view = view

    def run_(self, args):
        if args:
            if 'event' in args:
                del args['event']

            edit = self.view.begin_edit(self.name(), args)
            try:
                return self.run(edit, **args)
            finally:
                self.view.end_edit(edit)
        else:
            edit = self.view.begin_edit(self.name())
            try:
                return self.run(edit)
            finally:
                self.view.end_edit(edit)

    def run(self, edit):
        pass


class EventListener(object):
    pass
