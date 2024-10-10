//
//  ItemsListFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/23/24.
//

import ComposableArchitecture
import Foundation
import PoCampo
import OSLog

@Reducer
struct ItemsListFeature {

    @Dependency(\.itemCreationService) var itemCreationService
    @Dependency(\.widgetCreationService) var widgetCreationService
    @Dependency(\.itemFetchingStream) var itemFetchingStream

    let logger = Logger(subsystem: "com.jlo.ItemListFeature", category: "Feature")

    @ObservableState
    struct State {
        var items: [TrackedItemModel]
        @Presents var itemDetails: ItemDetailsFeature.State?
        @Presents var addItem: AddItemFeature.State?
        var stream: AsyncThrowingStream<[TrackedItemModel], Error>?
        var showInfo: Bool = false
    }

    enum Action {
        case itemDetails(PresentationAction<ItemDetailsFeature.Action>)
        case itemTapped(item: TrackedItemModel)
        case showInfo(item: TrackedItemModel)
        case addItemTapped
        case addItem(PresentationAction<AddItemFeature.Action>)
        case fetchItems
        case updateItems([TrackedItemModel])
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .itemTapped(item: item):
                logger.log("ItemsListFeature: Received action itemTapped \(item.uniqueId)")
                state.itemDetails = .init(item: item)
                return .none

            case .itemDetails:
                logger.log("ItemsListFeature: Received action itemDetails")
                return .none

            case .updateItems(let items):
                logger.log("ItemsListFeature: Received action updateItems \(items.count)")
                state.items = items
                return .none

            case .fetchItems:
                logger.log("ItemsListFeature: Received action fetchItems")
                return .run { send in
                    for try await items in itemFetchingStream.streamItems() {
                        await send(.updateItems(items))
                    }
                }

            case .addItemTapped:
                logger.log("ItemsListFeature: Received action addItemTapped")
                state.addItem = .init()
                return .none

            case let .showInfo(item: item):
                logger.log("ItemsListFeature: Received action showInfo \(item.uniqueId)")
                state.showInfo.toggle()
                return .none

            case .addItem(let action):
                switch action {
                case .dismiss:
                    return .none

                case .presented(let addItemAction):
                    switch addItemAction {
                    case .createItem:
                        logger.log("ItemsListFeature: Received action createItem")
                        guard let addItemState = state.addItem else { return .none }

                        let uniqueId = UUID().uuidString
                        let selectedWidgetType = addItemState.widgetTypeSelectionState.selectedOption
                        let widgetType: WidgetModel.WidgetType
                        let trackedValueType: TrackedValueType

                        switch selectedWidgetType {
                        case .textOnly:
                            widgetType = .textOnly(TextOnlyWidgetModel(uniqueId: uniqueId))
                            trackedValueType = .text
                        case .counter:
                            widgetType = .counter(CounterWidgetModel(uniqueId: uniqueId,
                                                                     incrementValue: addItemState.counterOptionsState.incrementValueSelectionState.selectedOption.rawValue,
                                                                     measurement: addItemState.counterOptionsState.itemMeasurementSelectionState.selectedOption))
                            trackedValueType = .number
                        case .bookCounter:
                            widgetType = .bookCounter(.init(uniqueId: uniqueId, title: "", creator: ""))
                            trackedValueType = .book
                        }

                        let widget = WidgetModel(uniqueId: uniqueId, type: widgetType)
                        let name = addItemState.nameSelectionState.name
                        let color = addItemState.colorSelectionState.selectedOption

                        state.addItem = nil
                        return .run { _ in
                            let widgetModel = try await self.widgetCreationService.createWidget(widgetModel: widget)
                            let _ = try await self.itemCreationService.createItem(name: name,
                                                                                  color: color,
                                                                                  widgetModel: widgetModel,
                                                                                  valueType: trackedValueType)
                        }
                        
                    case .cancel:
                        state.addItem = nil
                        return .none

                    default:
                        return .none
                    }
                }
            }
        }
        .ifLet(\.$itemDetails, action: \.itemDetails) {
            ItemDetailsFeature()
        }
        .ifLet(\.$addItem, action: \.addItem) {
            AddItemFeature()
        }
    }
}

