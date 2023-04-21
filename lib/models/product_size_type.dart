import 'package:Niajiri/models/categorical.dart';
import 'package:Niajiri/models/numerical.dart';

class ProductSizeType {
  List<Numerical>? numerical;
  List<Categorical>? categorical;

  ProductSizeType({this.numerical, this.categorical});
}
