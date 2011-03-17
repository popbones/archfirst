﻿/*
 * From Colin Eberhardt's post at
 * http://www.scottlogic.co.uk/blog/colin/2010/05/silverlight-multibinding-solution-for-silverlight-4/
 */
using System;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Windows;
using System.Windows.Data;
using System.Windows.Markup;

namespace Archfirst.Framework.SilverlightMultiBinding
{
    [ContentProperty("Bindings")]
    public class MultiBindings : FrameworkElement
    {
        private FrameworkElement _targetElement;

        public ObservableCollection<MultiBinding> Bindings { get; set; }

        public MultiBindings()
        {
            Bindings = new ObservableCollection<MultiBinding>();
        }
#if !SILVERLIGHT
        void Loaded(object sender, RoutedEventArgs e)
        {
            _targetElement.Loaded -= Loaded;
            foreach (MultiBinding binding in Bindings)
            {
                FieldInfo field = _targetElement.GetType().GetField(binding.TargetProperty + "Property", BindingFlags.Public | BindingFlags.Static | BindingFlags.FlattenHierarchy);
                if (field == null) continue;

                System.Windows.Data.MultiBinding newBinding = new System.Windows.Data.MultiBinding
                                                                  {
                                                                      Converter = binding.Converter,
                                                                      ConverterParameter = binding.ConverterParameter
                                                                  };
                foreach (BindingBase bindingBase in binding.Bindings)
                {
                    newBinding.Bindings.Add(bindingBase);
                }
                
                DependencyProperty dp = (DependencyProperty)field.GetValue(_targetElement);

                BindingOperations.SetBinding(_targetElement, dp, newBinding);
            }

        }
#endif

        public void SetDataContext(object dataContext)
        {
            foreach (MultiBinding relay in Bindings)
            {
                relay.DataContext = dataContext;
            }
        }

        public void Initialize(FrameworkElement targetElement)
        {
            _targetElement = targetElement;
#if !SILVERLIGHT
            _targetElement.Loaded += Loaded;
#else
            const BindingFlags DpFlags = BindingFlags.Public | BindingFlags.Static | BindingFlags.FlattenHierarchy;

            foreach (MultiBinding relay in Bindings)
            {
                relay.Initialise();

                // find the target dependency property
                Type targetType = null;
                string targetProperty = null;

                // assume it is an attached property if the dot syntax is used.
                if (relay.TargetProperty.Contains("."))
                {
                    // split to find the type and property name
                    string[] parts = relay.TargetProperty.Split('.');
                    targetType = Type.GetType("System.Windows.Controls." + parts[0] +
                                              ", System.Windows, Version=2.0.5.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e");
                    targetProperty = parts[1];
                }
                else
                {
                    targetType = targetElement.GetType();
                    targetProperty = relay.TargetProperty;
                }

                FieldInfo[] sourceFields = targetType.GetFields(DpFlags);
                FieldInfo targetDependencyPropertyField =
                    sourceFields.First(i => i.Name == targetProperty + "Property");
                DependencyProperty targetDependencyProperty =
                    targetDependencyPropertyField.GetValue(null) as DependencyProperty;

                // bind the ConvertedValue of our MultiBinding instance to the target property
                // of our targetElement
                Binding binding = new Binding("ConvertedValue") {
                    Source = relay,
                    // Mode = relay.Mode,
                    TargetNullValue = relay.TargetNullValue
                };
                Debug.WriteLine("---> MultiBindings.Initialize - "
                    + "targetType=" + targetType
                    + ", targetProperty=" + targetProperty
                    + ", targetElement=" + targetElement
                    + ", targetDependencyProperty=" + targetDependencyProperty
                    + ", dataContext=" + targetElement.DataContext
                    );
                targetElement.SetBinding(targetDependencyProperty, binding);
                Debug.WriteLine("<--- MultiBindings.Initialize");
            }
#endif
        }
    }
}