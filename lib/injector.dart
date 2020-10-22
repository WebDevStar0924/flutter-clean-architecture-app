import 'package:get/get.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

import 'app/data/api/api.dart';
import 'app/data/datasources/local/articles_local_datasource.dart';
import 'app/data/datasources/remote/articles_remote_datasource.dart';

import 'app/data/datasources/local/articles_local_datasource_sembast.dart';

import 'app/data/repositories/articles_repository_impl.dart';
import 'app/domain/repositories/articles_repository.dart';

import 'app/domain/usecases/get_local_articles.dart';
import 'app/domain/usecases/get_remote_articles.dart';

import 'app/core/network/network_info.dart';

import 'app/presentation/home_bloc/bloc/bloc.dart';

// inject app dependencies
Future<void> injectDependencies() async {
  // create a RestClient instace
  final client = RestClient(Dio(BaseOptions(contentType: "application/json")));
  // Data sources
  Get.lazyPut<ArticlesRemoteDatasource>(
      () => ArticlesRemoteDatasource(client: client));
  Get.putAsync<ArticlesLocalDatasource>(() async {
    final service = ArticlesLocalDatasourceSembastImpl();
    await service.initDb();
    return service;
  });

  // Use cases
  Get.lazyPut<GetLocalArticles>(
      () => GetLocalArticles(Get.find<ArticlesRepository>()));
  Get.lazyPut<GetRemoteArticles>(
      () => GetRemoteArticles(Get.find<ArticlesRepository>()));

  // Repository
  Get.lazyPut<ArticlesRepository>(() => ArticlesRepositoryImpl(
      localDataSource: Get.find<ArticlesLocalDatasource>(),
      remoteDataSource: Get.find<ArticlesRemoteDatasource>()));

  // Core
  Get.lazyPut(() => NetworkInfo(connectivity: Connectivity()));

  /// BloC
  Get.lazyPut<ArticlesBloc>(() => ArticlesBloc(const Initial()));
}
