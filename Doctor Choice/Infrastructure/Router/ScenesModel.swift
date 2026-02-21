enum AppScenes: Hashable {
    case main(MainSceneRoute)
}

enum MainSceneRoute: Hashable {
    case pediatricianDetail(User)
}
