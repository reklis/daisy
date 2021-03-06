Concept
-------

A lightweight framework for async operations, intentionally avoiding
crazy amounts of inheritance.  The idea is to generate code as a starting
point, and be easy enough to use that codegen is not required.

Usage
-----

From your iPhone project

  #import "DynamicData.h"


Optionally use xml2objc.py to codegen Command, Model, View, and Controller
classes.

To create your own commands you can inherit from **XmlHttpRequestCommand** or
build your own using **AsyncXmlHttpRequest**

Any controller will do, **UIViewController** for single records,
**UITableViewController** for collections seems to work well.  You can use 
**LoadingDataSource** and **EmptyDataSource** as transitional datasources.

A number of Categories are provided to reduce code in UITableViewControllers,
this way you don't have to inherit from some custom base class and you can
continue to use your own model uninterrupted.


---

[![gittip](http://img.shields.io/gittip/reklis.svg)](https://www.gittip.com/reklis/)
