/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.giraph.aggregators;

import org.apache.hadoop.io.LongWritable;

/**
 * Aggregator for summing up long values, with ability to reset.
 */
public class LongSumResetAggregator extends BasicAggregator<LongWritable> {
  /** Sentinel value to reset aggregator sum. **/
  public static final LongWritable RESET = new LongWritable(Long.MAX_VALUE);

  @Override
  public void aggregate(LongWritable value) {
    if (value.get() == RESET.get()) {
      getAggregatedValue().set(0);
      return;
    }

    getAggregatedValue().set(getAggregatedValue().get() + value.get());
  }

  @Override
  public LongWritable createInitialValue() {
    return new LongWritable(0);
  }
}