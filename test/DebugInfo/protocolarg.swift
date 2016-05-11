// RUN: %target-swift-frontend %s -emit-ir -g -o - | FileCheck %s

func markUsed<T>(_ t: T) {}

public protocol IGiveOutInts {
  func callMe() -> Int64
}

// CHECK: define {{.*}}@_TF11protocolarg16printSomeNumbersFPS_12IGiveOutInts_T_
// CHECK: @llvm.dbg.declare(metadata %P11protocolarg12IGiveOutInts_** %
// CHECK-SAME:              metadata ![[ARG:[0-9]+]], metadata ![[DEREF:[0-9]+]])
// CHECK: @llvm.dbg.declare(metadata %P11protocolarg12IGiveOutInts_* %
// CHECK-SAME:              metadata ![[VAR:[0-9]+]], metadata ![[EMPTY:[0-9]+]])

// FIXME: Should be DW_TAG_interface_type
// CHECK: !DICompositeType(tag: DW_TAG_structure_type, name: "IGiveOutInts"
// CHECK-SAME:             identifier: [[PT:"[^"]+"]]

public func printSomeNumbers(_ gen: IGiveOutInts) {
  let gen = gen
  // CHECK: ![[EMPTY]] = !DIExpression()
  // CHECK: ![[ARG]] = !DILocalVariable(name: "gen", arg: 1,
  // CHECK-SAME:                        line: [[@LINE-4]], type: ![[PT]]
  // CHECK: ![[DEREF]] = !DIExpression(DW_OP_deref)
  // CHECK: ![[VAR]] = !DILocalVariable(name: "gen", {{.*}} line: [[@LINE-5]]
  markUsed(gen.callMe())
}

