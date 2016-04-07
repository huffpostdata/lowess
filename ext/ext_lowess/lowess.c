#include <ruby.h>

static VALUE Lowess;
static VALUE Lowess_Point;

static ID X;
static ID Y;
static ID Point;

void clowess(double *x, double *y, int n,
             double f, int nsteps, double delta,
             double *ys, double *rw, double *res);

static VALUE
lowess_ext_lowess(VALUE self, VALUE in_points, VALUE in_f, VALUE in_iter, VALUE in_delta) {
  const int len = RARRAY_LEN(in_points);

  double* xs = ALLOC_N(double, len);
  double* ys = ALLOC_N(double, len);

  const double f = NUM2DBL(in_f);
  const int iter = NUM2INT(in_iter);
  const double delta = NUM2DBL(in_delta);

  double* out_ys = ALLOC_N(double, len);
  double* rw = ALLOC_N(double, len);
  double* res = ALLOC_N(double, len);
  VALUE* points = ALLOC_N(VALUE, len);
  VALUE point_args[2];
  VALUE ret = rb_ary_new_capa(len);
  int i;

  VALUE e;
  for (i = 0; i < len; i++) {
    e = rb_ary_entry(in_points, i);
    xs[i] = NUM2DBL(rb_ivar_get(e, X));
    ys[i] = NUM2DBL(rb_ivar_get(e, Y));
  }

  clowess(xs, ys, len, f, iter, delta, out_ys, rw, res);

  for (i = 0; i < len; i++) {
    point_args[0] = DBL2NUM(xs[i]);
    point_args[1] = DBL2NUM(out_ys[i]);
    points[i] = rb_class_new_instance(2, point_args, Lowess_Point);
  }

  rb_ary_cat(ret, points, len);

  xfree(points);
  xfree(res);
  xfree(rw);
  xfree(out_ys);
  xfree(ys);
  xfree(xs);

  return ret;
}

void Init_ext_lowess() {
  X = rb_intern("@x");
  Y = rb_intern("@y");
  Point = rb_intern("Point");

  Lowess = rb_define_module("Lowess");
  Lowess_Point = rb_const_get(Lowess, Point);

  rb_define_singleton_method(Lowess, "ext_lowess", lowess_ext_lowess, 4);
}
