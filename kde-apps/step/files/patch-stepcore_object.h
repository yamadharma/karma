--- a/stepcore/object.h.orig	2024-02-10 03:35:30 UTC
+++ b/stepcore/object.h
@@ -249,7 +249,7 @@ _Dst stepcore_cast(_Src src) {
 /** Casts between pointers to Object */
 template<class _Dst, class _Src> // XXX: implement it better
 _Dst stepcore_cast(_Src src) {
-    if(!src || !src->metaObject()->template inherits(_Dst())) return NULL;
+    if(!src || !src->metaObject()->template inherits<_Dst>(_Dst())) return NULL;
     return static_cast<_Dst>(src);
 }