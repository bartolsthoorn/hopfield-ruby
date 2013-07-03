#include <ruby.h>

static VALUE m_hopfield;

static VALUE hopfield_calculate_weights_hebbian(VALUE self, VALUE patterns, VALUE neurons_count) {
  Check_Type(patterns, T_ARRAY);
  Check_Type(neurons_count, T_FIXNUM);
  
  int n_count = FIX2INT(neurons_count);
  
  VALUE weights;
  weights = rb_ary_new2(n_count);
  for(int i = 0; i < n_count-1; i++) {
    rb_ary_store(weights, i, rb_ary_new2(n_count));
  }
  
  int patterns_count = (int) RARRAY_LEN(patterns);
  
  for(int i = 0; i < n_count; i++) {
    for(int j = (i+1); j < n_count; j++) {
      if (j == i)
        continue;
      
      float weight = 0.0;
      for(int p = 0; p < patterns_count; p ++) {
        weight += FIX2INT(rb_ary_entry(rb_ary_entry(patterns, p), i)) * FIX2INT(rb_ary_entry(rb_ary_entry(patterns, p), j));
      }
      
      weight = weight / patterns_count;
      
      int w_i = (i < j) ? i : j;
      int w_j = (j > i) ? j : i;
      
      rb_ary_store(rb_ary_entry(weights, w_i), w_j, rb_float_new(weight));
    }
  }
  
  return weights;
}

/* ruby calls this to load the extension */
void Init_hopfield(void) {
  
  m_hopfield = rb_define_module("Hopfield");
  
  rb_define_module_function(m_hopfield, "calculate_weights_hebbian", hopfield_calculate_weights_hebbian, 2);
}