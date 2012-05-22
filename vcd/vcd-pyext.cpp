
#include <Python.h>
#include <string>
#include <sstream>
#include "vcd.hpp"

using namespace std;

struct VCD_Object {
    PyObject_HEAD;
    VCD *vcd;
};

struct Scope_Object {
    PyObject_HEAD;
    Module *module;
};

struct Signal_Object {
    PyObject_HEAD;
    Signal *signal;
};

static void VCD_dealloc(VCD_Object *self);
static void Scope_dealloc(Scope_Object *self);
static void Signal_dealloc(Signal_Object *self);
    
static PyObject* VCD_getattr(PyObject *self, PyObject *attrName);
static PyObject* Scope_getattr(PyObject *self, PyObject *attrName);
static PyObject* Scope_call(PyObject *self, PyObject *args, PyObject *kw);
static PyObject* Signal_changes(PyObject *self, PyObject *args);

static PyTypeObject VCD_Type = {
    PyObject_HEAD_INIT(NULL)
    0,                        // ob_size
    "vcd.VCD",                // tp_name
    sizeof(VCD_Object),       // tp_basicsize
    0,                        // tp_itemsize
    (destructor) VCD_dealloc, // tp_dealloc
    0,                        // tp_print
    0,                        // tp_getattr
    0,                        // tp_setattr
    0,                        // tp_compare
    0,                        // tp_repr
    0,                        // tp_as_number
    0,                        // tp_as_sequence
    0,                        // tp_as_mapping
    0,                        // tp_hash
    0,                        // tp_call
    0,                        // tp_str
    VCD_getattr,              // tp_getattro
    0,                        // tp_setattro
    0,                        // tp_as_buffer
    Py_TPFLAGS_DEFAULT,
    "A parsed VCD file"
};

static PyTypeObject Scope_Type = {
    PyObject_HEAD_INIT(NULL)
    0,                          // ob_size
    "vcd.Scope",                // tp_name
    sizeof(Scope_Object),       // tp_basicsize
    0,                          // tp_itemsize
    (destructor) Scope_dealloc, // tp_dealloc
    0,                          // tp_print
    0,                          // tp_getattr
    0,                          // tp_setattr
    0,                          // tp_compare
    0,                          // tp_repr
    0,                          // tp_as_number
    0,                          // tp_as_sequence
    0,                          // tp_as_mapping
    0,                          // tp_hash
    Scope_call,                 // tp_call
    0,                          // tp_str
    Scope_getattr,              // tp_getattro
    0,                          // tp_setattro
    0,                          // tp_as_buffer
    Py_TPFLAGS_DEFAULT,         // tp_flags
    "A scope in the design (aka module)", // tp_doc
};

static PyMethodDef Signal_methods[] = {
    {"changes", Signal_changes, METH_VARARGS, "Get the signal changes as a list of tuples"},
    {NULL, NULL, 0, NULL}
};

static PyTypeObject Signal_Type = {
    PyObject_HEAD_INIT(NULL)
    0,                           // ob_size
    "vcd.Signal",                // tp_name
    sizeof(Signal_Object),       // tp_basicsize
    0,                           // tp_itemsize
    (destructor) Signal_dealloc, // tp_dealloc
    0,                           // tp_print
    0,                           // tp_getattr
    0,                           // tp_setattr
    0,                           // tp_compare
    0,                           // tp_repr
    0,                           // tp_as_number
    0,                           // tp_as_sequence
    0,                           // tp_as_mapping
    0,                           // tp_hash
    0,                           // tp_call
    0,                           // tp_str
    0,                           // tp_getattro
    0,                           // tp_setattro
    0,                           // tp_as_buffer
    Py_TPFLAGS_DEFAULT,
    "A signal in a VCD file"
};

static void VCD_dealloc(VCD_Object *self) {
    delete self->vcd;
    self->ob_type->tp_free((PyObject*) self);
}

static void Scope_dealloc(Scope_Object *self) {
    delete self->module;
    self->ob_type->tp_free((PyObject*) self);
}

static void Signal_dealloc(Signal_Object *self) {
    delete self->signal;
    self->ob_type->tp_free((PyObject*) self);
}

static PyObject* VCD_getattr(PyObject *self, PyObject *attrName) {
    PyObject *better = PyObject_GenericGetAttr(self, attrName);
    if (better != NULL) return better;
    PyErr_Clear();
    
    const char* name;
    name = PyString_AsString(attrName);
    
    VCD &vcd = *((VCD_Object*) self)->vcd;
    Module modu = vcd & name;
    if (!(modu.existsAsSignal() || modu.existsAsScope())) {
        PyErr_SetString(PyExc_AttributeError, name);
        return NULL;
    }
    
    Scope_Object *obj = (Scope_Object*) Scope_Type.tp_alloc(&Scope_Type, 0);
    if (obj != NULL)
        obj->module = new Module(modu);
    return (PyObject*) obj;
}

static PyObject* Scope_getattr(PyObject *self, PyObject *attrName) {
    PyObject *better = PyObject_GenericGetAttr(self, attrName);
    if (better != NULL) return better;
    PyErr_Clear();
    
    const char* name;
    name = PyString_AsString(attrName);
    
    Module &modu = *((Scope_Object*) self)->module;
    Module next = modu & name;
    if (!(next.existsAsSignal() || next.existsAsScope())) {
        PyErr_SetString(PyExc_AttributeError, name);
        return NULL;
    }
    
    Scope_Object *obj = (Scope_Object*) Scope_Type.tp_alloc(&Scope_Type, 0);
    if (obj != NULL)
        obj->module = new Module(next);
    return (PyObject*) obj;
}

static PyObject* Scope_call(PyObject *self, PyObject *args, PyObject *kw) {
    Module &modu = *((Scope_Object*) self)->module;
    Signal_Object *obj = (Signal_Object*) Signal_Type.tp_alloc(&Signal_Type, 0);
    
    if (!modu.existsAsSignal()) {
        PyErr_SetString(PyExc_AttributeError, modu.prefix.c_str());
        return NULL;
    }
    
    if (obj != NULL)
        obj->signal = new Signal(modu.asSignal());
    return (PyObject*) obj;
}

static PyObject* Signal_changes(PyObject *self, PyObject *args) {
    Signal &sig = *((Signal_Object*)self)->signal;
    vector<Change> changes = sig.changes();
    
    PyObject* list = PyList_New(changes.size());
    for (int i=0; i<changes.size(); i++) {
        Change ch = changes[i];
        ostringstream f;
        f << ch.value;
        PyList_SetItem(list, i, Py_BuildValue("(l,s)", ch.time, f.str().c_str()));
    }
    return list;
}

static PyObject* vcd_parse_vcd(PyObject *mod, PyObject *args) {
    const char* path;
    if (!PyArg_ParseTuple(args, "s", &path)) return NULL;
    
    VCD *vcd = new VCD(path);
    
    VCD_Object *self;
    self = (VCD_Object*) VCD_Type.tp_alloc(&VCD_Type, 0);
    if (self != NULL) {
        self->vcd = vcd;
    }
    return (PyObject*) self;
}

static PyMethodDef vcdMethods[] = {
    {"parse_vcd", vcd_parse_vcd, METH_VARARGS, "Parse a VCD file"},
    {NULL, NULL, 0, NULL}
};

// extern "C" is implied
PyMODINIT_FUNC initvcd() {
    VCD_Type.tp_new = PyType_GenericNew;
    if (PyType_Ready(&VCD_Type) < 0) return;
    
    Scope_Type.tp_new = PyType_GenericNew;
    if (PyType_Ready(&Scope_Type) < 0) return;
    
    Signal_Type.tp_methods = Signal_methods;
    Signal_Type.tp_new = PyType_GenericNew;
    if (PyType_Ready(&Signal_Type) < 0) return;
    
    Py_InitModule3("vcd", vcdMethods,
        "A library for parsing VCD (Value Change Dump) files.");
    Py_INCREF(&VCD_Type);
    Py_INCREF(&Scope_Type);
    Py_INCREF(&Signal_Type);
}

